import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:street_calle/main.dart';


class StripeService {

  final client = http.Client();
  static const baseUrl = 'https://us-central1-street-calle-72cff.cloudfunctions.net/app';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $SECRET_KEY',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  /// Common Methods
  void _init() {
    Stripe.publishableKey = 'pk_test_51OWngYJv1vWNPW79uHaAaIAB0xePSGpygIqwnFZ6JPqIn3qArtK5gD092eWNvKPoSPbRyv0AaNkqOv6b6vmjgk5g00QfjuzUTZ';
  }
  // Future<Map<String, dynamic>> _createCustomer() async {
  //   const String url = 'https://api.stripe.com/v1/customers';
  //   var response = await client.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: {
  //       'description': 'new customer',
  //       'email': 'shehzadraheem.sr38@gmail.com'
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to register as a customer.';
  //   }
  // }
  // Future<Map<String, dynamic>> _createPaymentIntents() async {
  //   const String url = 'https://api.stripe.com/v1/payment_intents';
  //
  //   Map<String, dynamic> body = {
  //     'amount': '2000',
  //     'currency': 'usd',
  //     'payment_method_types[]': 'card'
  //   };
  //
  //   var response =
  //   await client.post(Uri.parse(url), headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to create PaymentIntents.';
  //   }
  // }

  /// One-Time Payment
  // Future<void> _createCreditCard(String customerId, String paymentIntentClientSecret) async {
  //
  //   await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         // applePay: true,
  //         // googlePay: true,
  //         // style: ThemeMode.dark,
  //         // testEnv: true,
  //         // merchantCountryCode: 'JP',
  //         merchantDisplayName: 'Flutter Stripe Store Demo',
  //         customerId: customerId,
  //         paymentIntentClientSecret: paymentIntentClientSecret,
  //       ));
  //
  //   await Stripe.instance.presentPaymentSheet();
  //
  // }
  // Future<void> payment() async {
  //   _init();
  //   final customer = await _createCustomer();
  //   final paymentIntent = await _createPaymentIntents();
  //   await _createCreditCard(customer['id'], paymentIntent['client_secret']);
  // }

  /// Subscription
  // Future<Map<String, dynamic>> _createPaymentMethod(
  //     {required String number,
  //       required String expMonth,
  //       required String expYear,
  //       required String cvc}) async {
  //   const String url = 'https://api.stripe.com/v1/payment_methods';
  //   var response = await client.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: {
  //       'type': 'card',
  //       'card[number]': number,
  //       'card[exp_month]': expMonth,
  //       'card[exp_year]': expYear,
  //       'card[cvc]': cvc,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to create PaymentMethod.';
  //   }
  // }
  //
  //
  // Future<Map<String, dynamic>> _attachPaymentMethod(String paymentMethodId, String customerId) async {
  //   final String url = 'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
  //   var response = await client.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: {
  //       'customer': customerId,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to attach PaymentMethod.';
  //   }
  // }
  //
  // Future<Map<String, dynamic>> _updateCustomer(
  //     String paymentMethodId, String customerId) async {
  //   final String url = 'https://api.stripe.com/v1/customers/$customerId';
  //
  //   var response = await client.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: {
  //       'invoice_settings[default_payment_method]': paymentMethodId,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to update Customer.';
  //   }
  // }
  //
  // Future<Map<String, dynamic>> _createSubscriptions(String customerId) async {
  //   const String url = 'https://api.stripe.com/v1/subscriptions';
  //
  //   Map<String, dynamic> body = {
  //     'customer': customerId,
  //     'items[0][price]': 'price_1OXJ05Jv1vWNPW79LdUrSUDC',
  //   };
  //
  //   var response =
  //   await client.post(Uri.parse(url), headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to register as a subscriber.';
  //   }
  // }
  //
  // Future<void> subscriptions() async {
  //   //_init();
  //   //final customer = await _createCustomer();
  //   final paymentMethod = await _createPaymentMethod(number: '4242424242424242', expMonth: '12', expYear: '34', cvc: '567');
  //   await _attachPaymentMethod(paymentMethod['id'], 'cus_PMPlXsO9aGAQOW');
  //   await _updateCustomer(paymentMethod['id'], 'cus_PMPlXsO9aGAQOW');
  //   await _createSubscriptions('cus_PMPlXsO9aGAQOW');
  //   //await _createSubscriptions(customer['id']);
  // }


  ///Different
  // Future<void> init() async {
  //   _init();
  //  // Map<String, dynamic> customer = await createCustomer();
  //   //Map<String, dynamic> paymentIntent = await createPaymentIntentDouble('cus_PMPlXsO9aGAQOW');
  //   //await createCreditCard('cus_PMPlXsO9aGAQOW', paymentIntent['client_secret']);
  //   await createCreditCard('cus_PMPlXsO9aGAQOW', 'pi_3OYkAkJv1vWNPW790j3Fk8Zs_secret_UfajrbCp8s0p6hyCmXu0Z9EVy');
  //   Map<String, dynamic> customerPaymentMethods = await getCustomerPaymentMethods('cus_PMPlXsO9aGAQOW');
  //
  //   await createSubscription(
  //     'cus_PMPlXsO9aGAQOW',
  //     customerPaymentMethods['data'][0]['id'],
  //   );
  //
  //  // checkAndCancelSubscription('sub_1OXgx8Jv1vWNPW79qhePqyp3');
  // }
  //
  // Future<Map<String, dynamic>> createCustomer() async {
  //   final customerCreationResponse = await apiService(
  //     endpoint: 'customers',
  //     requestMethod: ApiServiceMethodType.post,
  //     requestBody: {
  //       'description': 'new customer',
  //       'email': 'shehzadraheem.sr38@gmail.com'
  //     },
  //   );
  //
  //   return customerCreationResponse!;
  // }
  //
  // Future<Map<String, dynamic>> createPaymentIntent(String customerId) async {
  //   final paymentIntentCreationResponse = await apiService(
  //     requestMethod: ApiServiceMethodType.post,
  //     endpoint: 'setup_intents',
  //     requestBody: {
  //       'customer': customerId,
  //       'automatic_payment_methods[enabled]': 'true',
  //     },
  //   );
  //
  //   return paymentIntentCreationResponse!;
  // }
  //
  // Future<Map<String, dynamic>> createPaymentIntentDouble(String customerId) async {
  //   final paymentIntentCreationResponse = await apiService(
  //     requestMethod: ApiServiceMethodType.post,
  //     endpoint: 'payment_intents',
  //     requestBody: {
  //       'amount': '2000',
  //       'currency': 'usd',
  //       'automatic_payment_methods[enabled]' : 'true'
  //     },
  //   );
  //
  //   // final paymentIntentCreationResponse = await apiService(
  //   //   requestMethod: ApiServiceMethodType.get,
  //   //   endpoint: 'payment_intents',
  //   //   requestBody: {
  //   //
  //   //   },
  //   // );
  //
  //
  //   print('iii ${paymentIntentCreationResponse!}');
  //   return paymentIntentCreationResponse!;
  // }
  //
  static Future<void> createCreditCard(
      String customerId,
      String paymentIntentClientSecret,
      String ephemeralKey ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        //primaryButtonLabel: 'Subscribe \$10.00',
        testEnv: true,
        currencyCode: 'usd',
        merchantCountryCode: 'US',
        style: ThemeMode.light,
        merchantDisplayName: 'Street-Calle',
        customerId: customerId,
        //setupIntentClientSecret: paymentIntentClientSecret,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerEphemeralKeySecret: ephemeralKey
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }
  //
  // Future<Map<String, dynamic>> getCustomerPaymentMethods(
  //     String customerId,
  //     ) async {
  //   final customerPaymentMethodsResponse = await apiService(
  //     endpoint: 'customers/$customerId/payment_methods',
  //     requestMethod: ApiServiceMethodType.get,
  //   );
  //
  //   return customerPaymentMethodsResponse!;
  // }
  //
  // Future<Map<String, dynamic>> createSubscription(
  //     String customerId,
  //     String paymentId,
  //     ) async {
  //   final subscriptionCreationResponse = await apiService(
  //     endpoint: 'subscriptions',
  //     requestMethod: ApiServiceMethodType.post,
  //     requestBody: {
  //       'customer': customerId,
  //       'items[0][price]': 'price_1OXJ05Jv1vWNPW79LdUrSUDC',
  //       'default_payment_method': paymentId,
  //       'trial_end': DateTime.now().add(const Duration(days: 60)).toUtc().toIso8601String(),
  //       'automatic_tax': {
  //         'enabled': true
  //       },
  //     },
  //   );
  //
  //   return subscriptionCreationResponse!;
  // }

  // Future<void> checkAndCancelSubscription(String subscriptionId) async {
  //   // Retrieve subscription details
  //   final subscriptionDetails = await apiService(
  //     endpoint: 'subscriptions/$subscriptionId',
  //     requestMethod: ApiServiceMethodType.get,
  //   );
  //
  //   print(subscriptionDetails);
  //   // if (subscriptionDetails != null && subscriptionDetails.containsKey('status')) {
  //   //   final subscriptionStatus = subscriptionDetails['status'];
  //   //
  //   //   // // Cancel the subscription
  //   //   // final cancellationResponse = await apiService(
  //   //   //   endpoint: 'subscriptions/$subscriptionId',
  //   //   //   requestMethod: ApiServiceMethodType.delete,
  //   //   // );
  //   //   //
  //   //   // print(cancellationResponse);
  //   //
  //   //   // // Check if the subscription is in the trial period
  //   //   // if (subscriptionStatus == 'trialing') {
  //   //   //   // // Cancel the subscription
  //   //   //   // final cancellationResponse = await apiService(
  //   //   //   //   endpoint: 'subscriptions/$subscriptionId',
  //   //   //   //   requestMethod: ApiServiceMethodType.post,
  //   //   //   // );
  //   //   //
  //   //   // } else {
  //   //   //   // Subscription is not in the trial period
  //   //   //   print('Subscription is not in the trial period. No cancellation needed.');
  //   //   // }
  //   // } else {
  //   //   // Unable to retrieve subscription details
  //   //   print('Unable to retrieve subscription details.');
  //   // }
  // }

  /// Cloud Functions

  static Future<Map<String, dynamic>> createCustomer(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createCustomer'),
      headers: headers,
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create customer: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> createEphemeralKey(String customerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ephemeralKey'),
        headers: headers,
        body: {'customerId': customerId},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create ephemeral key: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle other errors here
      throw Exception('Failed to create ephemeral key: $error');
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String customerId) async {
    final response = await http.post(
      Uri.parse('https://us-central1-street-calle-72cff.cloudfunctions.net/app/createPaymentIntent'),
      headers: headers,
      body: {'amount': amount, 'customerId': customerId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment intent: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> getCustomerPaymentMethods(String customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getCustomerPaymentMethods?customerId=$customerId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get customer payment methods: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> createSubscription(String customerId, String paymentId, String priceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subscription'),
      headers: headers,
      body: {'customerId': customerId, 'paymentId': paymentId, 'priceId': priceId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create subscription: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> updateSubscription(String customerId, String paymentId, String priceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/updateSubscription'),
      headers: headers,
      body: {'customerId': customerId, 'paymentId': paymentId, 'priceId': priceId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update subscription: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> cancelSubscription(String subscriptionId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cancelSubscription?subscriptionId=$subscriptionId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to cancel subscription: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> getSubscriptionId(String customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getUserSubscriptionId?customerId=$customerId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get subscription id: ${response.reasonPhrase}');
    }
  }
}