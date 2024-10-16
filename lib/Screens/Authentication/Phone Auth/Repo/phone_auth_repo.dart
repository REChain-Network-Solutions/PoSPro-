import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../../../../Const/api_config.dart';
import '../../../../Repository/constant_functions.dart';
import '../../profile_setup_screen.dart';
import '../../success_screen.dart';

class PhoneAuthRepo {
  Future<bool> sentOTP({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${APIConfig.url}/send-otp');
    final body = {
      'phone': phoneNumber,
    };
    final headers = {
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      final errorData = jsonDecode(response.body);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorData['message'])));

        return true;
      } else {
        EasyLoading.showError(errorData['message']);
      }
    } catch (error) {
      EasyLoading.showError('Network error: Please try again');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error: Please try again')));
    } finally {}

    return false;
  }

  Future<void> submitOTP({
    required String phoneNumber,
    required String otp,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${APIConfig.url}/submit-otp');
    final body = {
      'phone': phoneNumber,
      'otp': otp,
    };
    final headers = {
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      final data = jsonDecode(response.body);
      print(response.statusCode);

      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
        // await saveUserData(userData: data);
        bool isSetup = data['is_setup'] ?? false;
        if (isSetup) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(email: 'phone')));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSetup()));
        }
      } else {
        EasyLoading.showError(data['message']);
      }
    } catch (error) {
      print(error);
      EasyLoading.showError('Network error: Please try again');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error: Please try again')));
    } finally {}
  }
}
