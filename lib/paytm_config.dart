// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
//
// class PaytmConfig {
//   final String _mid = "...";
//   final String _mKey = "...";
//   final String _website = "DEFAULT"; // or "WEBSTAGING" in Testing
//   final String _url = 'https://flutter-paytm-backend.herokuapp.com/generateTxnToken'; // Add your own backend URL
//
//   String get mid => _mid;
//   String get mKey => _mKey;
//   String get website => _website;
//   String get url => _url;
//
//   String getMap(double amount, String callbackUrl, String orderId) {
//     return json.encode({
//       "mid": mid,
//       "key_secret": mKey,
//       "website": website,
//       "orderId": orderId,
//       "amount": amount.toString(),
//       "callbackUrl": callbackUrl,
//       "custId":  "", // Pass users Customer ID here
//     });
//   }
//
//   Future<void> generateTxnToken(double amount, String orderId) async {
//     final callBackUrl = 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
//     final body = getMap(amount, callBackUrl, orderId);
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//       String txnToken = response.body;
//       await initiateTransaction(orderId, amount, txnToken, callBackUrl);
//     } catch (e) {
//       EasyLoading.showError(e.toString());
//     }
//   }
//
//   Future<void> initiateTransaction(String orderId, double amount, String txnToken, String callBackUrl) async {
//     try {
//       var response = AllInOneSdk.startTransaction(
//         mid,
//         orderId,
//         amount.toString(),
//         txnToken,
//         callBackUrl,
//         false, // isStaging
//         false, // restrictAppInvoke
//       );
//       response.then((value) {}).catchError((onError) {
//         if (onError is PlatformException) {
//           EasyLoading.showError("${onError.message!} \n  ${onError.details}");
//         } else {
//           EasyLoading.showError(onError.toString());
//         }
//       });
//     } catch (err) {
//       // Transaction failed
//       EasyLoading.showError(err.toString());
//     }
//   }
// }
