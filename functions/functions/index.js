/* eslint-disable max-len */
const functions = require("firebase-functions");
const Stripe = require("stripe");
const admin = require("firebase-admin");
const cors = require("cors");
const express = require("express");
require("dotenv").config();

const stripeTestKey = process.env.STRIPE_TEST_KEY;

// eslint-disable-next-line new-cap
const stripe = Stripe(stripeTestKey);

admin.initializeApp();

const app = express();
app.use(express.json());
app.use(cors());

app.post("/plans", async (req, res) => {
  try {
    const products = await stripe.products.list({limit: 10});
    res.status(200).json({result: products});
  } catch (error) {
    console.error("Error retrieving account details:", error);
    res.status(500).json({result: error.message});
  }
  return null;
});

const handleStripeError = (error, res) => {
  if (error.name === "StripeApiError") {
    const stripeError = error.error;
    return res.status(stripeError.statusCode || 500).json({
      msg: stripeError.message || "Stripe API Error",
      status: "failure",
    });
  } else {
    return res.status(500).json({msg: "Internal Server Error", status: "failure"});
  }
};

// Create Customer to get its stripeId (and save that id in firebase or other database)
// that will help us to figure out the particular user subscription
app.post("/createCustomer", async (req, res) => {
  try {
    if (req.body.email != null) {
      const customer = await stripe.customers.create({
        email: req.body.email,
      });

      if (customer != null && customer.id != null) {
        res.status(200).json({customer: customer.id, status: "success"});
      } else {
        res.status(400).json({
          msg: "Please contact admin. Unable to create customer.",
          status: "failure",
        });
      }
    } else {
      res.status(400).json({msg: "Please provide email", status: "failure"});
    }
  } catch (error) {
    console.error("Error:", error.message);
    handleStripeError(error, res);
  }
});

app.post("/ephemeralKey", async (req, res) => {
  try {
    if (req.body.customerId == null) {
      res.status(400).json({msg: "Unable to create ephemeral key. Customer ID is missing.", status: "failure"});
    } else {
      const ephemeralKey = await stripe.ephemeralKeys.create(
          {customer: req.body.customerId},
          {apiVersion: "2023-08-16"},
      );

      if (ephemeralKey != null) {
        res.status(200).json({ephemeralKey: ephemeralKey.secret, status: "success"});
      } else {
        res.status(400).json({msg: "Unable to create ephemeral key.", status: "failure"});
      }
    }
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({msg: "Internal Server Error", status: "failure"});
  }
});


// After creating Customer ask for payment intent
app.post("/createPaymentIntent", async (req, res) => {
  try {
    const {amount, customerId} = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: "usd",
      customer: customerId,
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.status(200).json({
      paymentIntent: paymentIntent.client_secret,
      customer: customerId,
      status: "success",
    });
  } catch (error) {
    console.error("Error:", error.message);
    handleStripeError(error, res);
  }
});

app.get("/getCustomerPaymentMethods", async (req, res) => {
  try {
    if (req.query.customerId != null) {
      const paymentMethod = await stripe.customers.listPaymentMethods(
          req.query.customerId,
          {
            limit: 1,
          },
      );

      if (paymentMethod != null) {
        res.status(200).json({paymentMethod: paymentMethod, status: "success"});
      } else {
        res.status(404).json({
          msg: "No payment method exist.",
          status: "failure",
        });
      }
    } else {
      res.status(400).json({msg: "Please provide customerId", status: "failure"});
    }
  } catch (error) {
    handleStripeError(error, res);
  }
});

app.post("/subscription", async (req, res) => {
  try {
    const {customerId, paymentId, priceId} = req.body;

    if (!customerId || !paymentId || !priceId) {
      return res.status(400).json({msg: "Customer ID or Payment ID is missing", status: "failure"});
    }

    const planPriceId = priceId.toUpperCase();

    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: [
        {
          price: process.env[planPriceId],
        },
      ],
      trial_period_days: 60,
      default_payment_method: paymentId,
      automatic_tax: {
        enabled: true,
      },
    });

    return res.status(200).json({subscription: subscription, status: "success"});
  } catch (error) {
    console.error("Error:", error.message);
    handleStripeError(error, res);
  }
});

app.post("/updateSubscription", async (req, res) => {
  try {
    const subscription = await stripe.subscriptions.retrieve(
        req.body.subscriptionId,
    );
    const priceId = req.body.priceId.toUpperCase();
    const updatedSubscription = await stripe.subscriptions.update(
        req.body.subscriptionId, {
          items: [{
            id: subscription.items.data[0].id,
            price: process.env[priceId],
          }],
        },
    );

    res.status(200).json({subscription: updatedSubscription});
  } catch (error) {
    handleStripeError(error, res);
  }
});

app.delete("/cancelSubscription", async (req, res) => {
  try {
    const deletedSubscription = await stripe.subscriptions.cancel(
        req.query.subscriptionId,
    );

    res.status(200).json({subscription: deletedSubscription});
  } catch (error) {
    handleStripeError(error, res);
  }
});

app.get("/getUserSubscriptionId", async (req, res) => {
  try {
    const {customerId} = req.query;

    if (!customerId) {
      return res.status(400).json({msg: "Customer ID is missing", status: "failure"});
    }

    // Retrieve customer's subscriptions
    const subscriptions = await stripe.subscriptions.list({
      customer: customerId,
    });

    if (subscriptions.data.length === 0) {
      return res.status(404).json({
        msg: "No subscriptions found for the customer.",
        status: "failure",
      });
    }

    // Assuming you want the latest subscription ID
    const latestSubscriptionId = subscriptions.data[0].id;

    return res.status(200).json({
      subscriptionId: latestSubscriptionId,
      status: "success",
    });
  } catch (error) {
    console.error("Error:", error.message);
    handleStripeError(error, res);
  }
});


exports.app = functions.https.onRequest(app);
