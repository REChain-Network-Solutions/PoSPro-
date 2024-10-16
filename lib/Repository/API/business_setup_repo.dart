import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Repository/constant_functions.dart';

import '../../Screens/Home/home.dart';
import '../../Screens/Home/home_screen.dart';

class BusinessSetupRepo {
  Future<void> businessSetup({
    required String name,
    String? phone,
    required String categoryId,
    // required String languageCode,
    String? address,
    String? openingBalance,
    File? image,
    required BuildContext context,
  }) async {
    EasyLoading.show(status: 'Loading...', dismissOnTap: false);

    final uri = Uri.parse('${APIConfig.url}/business');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = await getAuthToken();
    request.headers['Accept'] = 'application/json';
    request.fields['companyName'] = name;
    request.fields['phoneNumber'] = phone ?? '';
    request.fields['business_category_id'] = categoryId;
    // request.fields['language'] = languageCode;
    if (address != null) request.fields['address'] = address;
    if (openingBalance != null) request.fields['shopOpeningBalance'] = openingBalance;
    if (image != null) {
      var picturePart = http.MultipartFile.fromBytes('pictureUrl', image.readAsBytesSync(), filename: image.path);
      request.files.add(picturePart);
    }

    var response = await request.send();
    final responseData = await response.stream.bytesToString();
    print(responseData);
    //final parsedData = jsonDecode(responseData);

    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile setup successful!')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile setup failed')));
      print('Profile setup failed: ${response.statusCode}');

      // Handle error response
    }
  }
}
