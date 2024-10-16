// ignore_for_file: file_names, unused_element, unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/model/business_info_model.dart';
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';
import '../Model/payment_credential_model.dart';
import '../Model/subscription_plan_model.dart';

class SubscriptionPlanRepo {
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<List<SubscriptionPlanModel>> fetchAllPlans() async {
    final uri = Uri.parse('${APIConfig.url}/plans');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body) as Map<String, dynamic>;

      final partyList = parsedData['data'] as List<dynamic>;
      return partyList.map((category) => SubscriptionPlanModel.fromJson(category)).toList();
      // Parse into Party objects
    } else {
      throw Exception('Failed to fetch Products');
    }
  }

  Future<PaymentCredentialModel> getPaymentCredential() async {
    final uri = Uri.parse('${APIConfig.url}/gateways');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body) as Map<String, dynamic>;

      final data = parsedData['data'];
      return PaymentCredentialModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch credential');
    }
  }

  Future<void> subscribePlan({
    required WidgetRef ref,
    required BuildContext context,
    required int planId,
    required String paymentMethod,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/subscribes');

    var responseData = await http.post(uri, headers: {
      "Accept": 'application/json',
      'Authorization': await getAuthToken(),
    }, body: {
      'plan_id': planId.toString(),
      'subscriptionMethod': paymentMethod,
    });

    try {
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscribe successful!')));
        var data = ref.refresh(businessInfoProvider);

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subscribe creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  Future<String?> paymentWithShurjoPay(
      {required BuildContext context,
      required SubscriptionPlanModel plan,
      required BusinessInformation businessInformation,
      required PaymentCredentialModel paymentCredential}) async {
    ShurjoPay shurjoPay = ShurjoPay();
    ShurjopayConfigs shurjoPayConfigs = ShurjopayConfigs(
      prefix: paymentCredential.merchantkeyPrefix,
      userName: paymentCredential.merchantuserName,
      password: paymentCredential.merchantPassword,
      clientIP: paymentCredential.shurjopayserverUrl,
    );

    //Create payment request model and initialize values.
    ShurjopayRequestModel shurjopayRequestModel = ShurjopayRequestModel(
      configs: shurjoPayConfigs,
      currency: "BDT",
      amount: plan.offerPrice != null ? plan.offerPrice!.toDouble() : plan.subscriptionPrice?.toDouble() ?? 0,
      orderID: "${paymentCredential.merchantkeyPrefix}${getRandomString(8)}",
      discountAmount: 0,
      discountPercentage: 0,
      customerName: businessInformation.companyName ?? '',
      customerPhoneNumber: businessInformation.phoneNumber ?? '',
      customerAddress: businessInformation.address ?? '',
      customerCity: "customer city",
      customerPostcode: "0000",
      returnURL: "return_url",
      cancelURL: "cancel_url",
    );

    //Calling makePayment() method to initiate payment process.
    ShurjopayResponseModel shurjopayResponseModel = await shurjoPay.makePayment(
      context: context,
      shurjopayRequestModel: shurjopayRequestModel,
    );
    print(shurjopayResponseModel.message);

    //Create a verification response model object to store the verifyPayment() method results
    ShurjopayVerificationModel shurjopayVerificationModel = ShurjopayVerificationModel();

    //If the status is true from makePayment() method result then, verify the payment by calling verifyPayment() method whenever you want.
    if (shurjopayResponseModel.status == true) {
      try {
        shurjopayVerificationModel = await shurjoPay.verifyPayment(
          orderID: shurjopayResponseModel.shurjopayOrderID!,
        );
        if (shurjopayVerificationModel.spCode == "1000") {
          // print("Payment Varified");
          // print(shurjopayVerificationModel.message);
          // print(shurjopayVerificationModel.address);
          // print(shurjopayVerificationModel.bankStatus);
          // print(shurjopayVerificationModel.invoiceNo);
          // print(shurjopayVerificationModel.customerOrderId);
          // print(shurjopayVerificationModel.method);
          // print(shurjopayVerificationModel.phoneNo);
          // print(shurjopayVerificationModel.spMessage);
          // print(shurjopayVerificationModel.transactionStatus);
          return shurjopayVerificationModel.method;
        } else {
          EasyLoading.showError(shurjopayVerificationModel.spMessage ?? '');
          return null;
        }
      } catch (error) {
        print(error.toString());
        return null;
      }
    }
    return null;
  }
}
