// ignore_for_file: file_names, unused_element, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Screens/Products/Providers/category,brans,units_provide.dart';

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';
import '../Model/unit_model.dart';

class UnitsRepo {
  Future<List<Unit>> fetchAllUnits() async {
    final uri = Uri.parse('${APIConfig.url}/units');

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': await getAuthToken(),
      });

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body) as Map<String, dynamic>;
        final categoryList = parsedData['data'] as List<dynamic>;
        return categoryList.map((unit) => Unit.fromJson(unit)).toList();
      } else {
        throw Exception('Failed to fetch units: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addUnit({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/units');

    try {
      var responseData = await http.post(uri, headers: {
        "Accept": 'application/json',
        'Authorization': await getAuthToken(),
      }, body: {
        'unitName': name,
      });
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
        var data1 = ref.refresh(unitsProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unit creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  ///_______Edit_Add_________________________________________
  Future<void> editUnit({
    required WidgetRef ref,
    required BuildContext context,
    required num id,
    required String name,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/units/$id');

    try {
      var responseData = await http.post(uri, headers: {
        "Accept": 'application/json',
        'Authorization': await getAuthToken(),
      }, body: {
        'unitName': name,
        '_method':'put',
      });
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update successful!')));
        var data1 = ref.refresh(unitsProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unit creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  ///_________delete_unit________________________
  Future<bool> deleteUnit({required BuildContext context, required num unitId}) async {
    final String apiUrl = '${APIConfig.url}/units/$unitId'; // Replace with your API URL

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': await getAuthToken(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete unit.')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
      return false;
    }
  }
}
