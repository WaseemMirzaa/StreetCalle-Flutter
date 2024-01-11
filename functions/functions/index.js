/* eslint-disable max-len */
const functions = require("firebase-functions");
const Stripe = require("stripe");
const admin = require("firebase-admin");
const cors = require("cors");
const express = require("express");

// eslint-disable-next-line new-cap
const stripe = Stripe(
    "sk_test_51OWngYJv1vWNPW79k3w3BMnCRaFIHJMWE4h2R0ODmdHdkzPspizvlRViqzeednzU6M50fKUp9TCOkhTh9fgZPDJs005VZasFb4",
);

admin.initializeApp();

const app = express();
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


// Create Customer to get its stripeId (and save that id in firebase or other database)
// that will help us to figure out the particular user subscription
app.post("/create_customer", async (req, res) => {
  if (req.body.email != null) {
    const customer = await stripe.customers.create({
      email: req.body.email,
    });

    if (customer != null && customer.id != null) {
      res.json({customer: customer.id, status: "success"});
    } else {
      res.json({
        msg: "Please contact admin. Unable to create customer.",
        status: "failure",
      });
    }
  } else {
    res.json({msg: "Please provide email", status: "failure"});
  }
});


app.post("/ephemeralKey", async (req, res) => {
  if (req.body.customer_id == null) {
    res.json({msg: "Unable to create emhemeral key.", status: "failure"});
  } else {
    const key = await stripe.ephemeralKeys.create(
        {customer: req.body.customer_id},
        {apiVersion: "2023-10-16"},
    );
    if (key != null) res.json({data: key});
    else {
      res.json({msg: "Unable to create emhemeral key.", status: "failure"});
    }
  }
});


app.post("/create-checkout-session", async (req, res) => {
  if (req.query.price_id != null) {
    await stripe.checkout.sessions.create({
      line_items: [
        {
          price: req.query.price_id,
          quantity: 1,
        },
      ],
      subscription_data: {
        trial_period_days: 60,
      },
      payment_method_collection: "always",
      mode: "subscription",
      success_url: "https://example.com/success",
      cancel_url: "https://example.com/cancel",
    }).then(
        (result) => {
          res.json({msg: "Success", status: "success", session: result});
        },
        (err) => {
          res.json({msg: "error", status: "error", session: err});
        },
    );
  } else {
    if (req.query.price_id == null) {
      return {success: false, msg: "Please provide Price ID"};
    }
  }
});

exports.app = functions.https.onRequest(app);
