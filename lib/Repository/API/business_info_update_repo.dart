import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_pos/Const/api_config.dart';

import '../constant_functions.dart';

class BusinessUpdateRepository {
  Future<bool> updateProfile({
    required String id,
    required String name,
    required String categoryId,
    String? phone,
    File? image,
    String? address,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/business/$id');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = await getAuthToken();

    request.fields['_method'] = 'put';
    request.fields['companyName'] = name;
    request.fields['business_category_id'] = categoryId;
    if (phone != null) request.fields['phoneNumber'] = phone;
    if (address != null) request.fields['address'] = address;
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes('pictureUrl', image.readAsBytesSync(), filename: image.path));
    }

    final response = await request.send();
  var da =   await response.stream.bytesToString();
  print(response.statusCode);
  print(da);
  print(categoryId);

    if (response.statusCode == 200) {
      return true; // Update successful
    } else {
      return false;
    }
  }
}
