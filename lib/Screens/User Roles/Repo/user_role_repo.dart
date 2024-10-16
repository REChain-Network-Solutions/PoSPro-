
//ignore_for_file: file_names, unused_element, unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Screens/User%20Roles/Model/user_role_model.dart';
import 'package:mobile_pos/Screens/User%20Roles/Provider/user_role_provider.dart';

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';

class UserRoleRepo {
  Future<List<UserRoleModel>> fetchAllUsers() async {
    final uri = Uri.parse('${APIConfig.url}/users');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body) as Map<String, dynamic>;

      final partyList = parsedData['data'] as List<dynamic>;
      return partyList.map((user) => UserRoleModel.fromJson(user)).toList();
      // Parse into Party objects
    } else {
      throw Exception('Failed to fetch Users');
    }
  }

  Future<void> addUser({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
    required String email,
    // required String email,
    // required String password,
    // required String passwordConfirmation,
    required Permission permission,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/users');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = await getAuthToken();
    request.fields.addAll({
      "name": name,
      "email": email,
      // "email": email,
      // "password": password,
      // "password_confirmation": passwordConfirmation,
    });
    request.fields.addAll(permission.toJson());

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final parsedData = jsonDecode(responseData);
    print(response.statusCode);
    print(parsedData);
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
      var data1 = ref.refresh(userRoleProvider);

      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User creation failed: ${parsedData['message']}')));
    }
  }

  Future<void> deleteUser({
    required String id,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final String apiUrl = '${APIConfig.url}/users/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': await getAuthToken(), // Implement your getAuthToken function
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully')));

        var data1 = ref.refresh(userRoleProvider);

        Navigator.pop(context); // Assuming you want to close the screen after deletion
        Navigator.pop(context); // Assuming you want to close the screen after deletion
      } else {
        final parsedData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: ${parsedData['message']}')));
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> updateUser({
    required String userId,
    required WidgetRef ref,
    required BuildContext context,
    required String userName,
    required String email,
    required Permission permission,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/users/$userId');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = await getAuthToken();

    request.fields.addAll({
      "_method": "put",
      "name": userName,
      "email": email,
    });
    request.fields.addAll(permission.toJson());

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    final parsedData = jsonDecode(responseData);

    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully!')));
      var data1 = ref.refresh(userRoleProvider);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Update failed: ${parsedData['message']}')));
    }
  }
}
