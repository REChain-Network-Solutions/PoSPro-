//ignore_for_file: avoid_print,unused_local_variable
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Const/api_config.dart';

import '../../../Repository/constant_functions.dart';
import '../Model/parties_model.dart';
import '../Provider/customer_provider.dart';

class PartyRepository {
  Future<List<Party>> fetchAllParties() async {
    final uri = Uri.parse('${APIConfig.url}/parties');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body) as Map<String, dynamic>;

      final partyList = parsedData['data'] as List<dynamic>;
      return partyList.map((category) => Party.fromJson(category)).toList();
      // Parse into Party objects
    } else {
      throw Exception('Failed to fetch parties');
    }
  }

  Future<void> addParty({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
    required String phone,
    required String type,
    File? image,
    String? email,
    String? address,
    String? due,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/parties');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = await getAuthToken();

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['type'] = type;
    if (email != null) request.fields['email'] = email;
    if (address != null) request.fields['address'] = address;
    if (due != null) request.fields['due'] = due; // Convert due to string
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes('image', image.readAsBytesSync(), filename: image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final parsedData = jsonDecode(responseData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
      var data1 = ref.refresh(partiesProvider);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Party creation failed: ${parsedData['message']}')));
    }
  }

  Future<void> updateParty({
    required String id,
    required WidgetRef ref,
    required BuildContext context,
    required String name,
    required String phone,
    required String type,
    File? image,
    String? email,
    String? address,
    String? due,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/parties/$id');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = await getAuthToken();

    request.fields['_method'] = 'put';
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['type'] = type;
    if (email != null) request.fields['email'] = email;
    if (address != null) request.fields['address'] = address;
    if (due != null) request.fields['due'] = due; // Convert due to string
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes('image', image.readAsBytesSync(), filename: image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    final parsedData = jsonDecode(responseData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully!')));
      var data1 = ref.refresh(partiesProvider);

      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Party Update failed: ${parsedData['message']}')));
    }
  }

  Future<void> deleteParty({
    required String id,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final String apiUrl = 'https://modus.delus.site/api/v1/parties/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': await getAuthToken(), // Implement your getAuthToken function
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Party deleted successfully')));

        var data1 = ref.refresh(partiesProvider);

        Navigator.pop(context); // Assuming you want to close the screen after deletion
        // Navigator.pop(context); // Assuming you want to close the screen after deletion
      } else {
        final parsedData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete party: ${parsedData['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> sendCustomerUdeSms({required num id, required BuildContext context}) async {
    final uri = Uri.parse('${APIConfig.url}/parties/$id');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonDecode(response.body)['message'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${jsonDecode((response.body))['message']}')));
    }
  }
}
