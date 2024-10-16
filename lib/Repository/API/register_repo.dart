import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Const/api_config.dart';
import '../constant_functions.dart';

class RegisterRepo {
  Future<bool> registerRepo({required String email, required String password, required String confirmPassword, required BuildContext context}) async {
    final url = Uri.parse('${APIConfig.url}${APIConfig.registerUrl}');
    final body = {
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    final headers = {
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
        // await saveUserData(userData: responseData['data']);

        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error: Please try again')));
    } finally {}

    return false;
  }
}
