import 'dart:developer';
import 'package:harkat_app/theme.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

class StripeController extends GetxController {
  Rx<bool> isloading = false.obs;
  Map<String, dynamic> paymentIntentData = {};

  Future makePayment({String amount, String currency}) async {
    try {
      isloading(true);
      log("Start processing");
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
            googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
            merchantDisplayName: 'Prospects',
            customerId: paymentIntentData['customer'],
            paymentIntentClientSecret: paymentIntentData['client_secret'],
            customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
          ),
        );
        displayPaymentSheet(amount);
      }
    } catch (e, s) {
      log('$e$s');
    } finally {
      isloading(false);
    }
  }

  displayPaymentSheet(amount) async {
    try {
      log("Display Sheet  ....");
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      printError(info: e.error.toString());
      if (e.error.code == FailureCode.Canceled) {
        log('User Cancel the Payment');
      } else {
        print("Exception Code does not match");
      }
    } catch (e) {
      log("exception" + e);
      // kErrorSnakBar("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51LeLQeJp2VgbvjXMhpvavaIU44xpmr896mmPhcPZmOfboCHmKHHBIkXDzPdU2CNikGLvGGSSLgnW7nrSvIpEaQjF00irLDg3oU',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      log("responce body ...");
      return jsonDecode(response.body);
    } catch (err) {
      throw ('err charging user: ${err.toString()}');
    }
  }
}
