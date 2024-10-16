//ignore_for_file: file_names, unused_element, unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pos/Screens/Products/Providers/category,brans,units_provide.dart';

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';
import '../Model/category_model.dart';

class CategoryRepo {
  Future<List<CategoryModel>> fetchAllCategory() async {
    final uri = Uri.parse('${APIConfig.url}/categories');

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': await getAuthToken(),
      });

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body) as Map<String, dynamic>;
        final categoryList = parsedData['data'] as List<dynamic>;
        return categoryList.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        // Handle specific error cases based on response codes
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      rethrow; // Re-throw to allow further handling upstream
    }
  }

  Future<void> addCategory({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
    required bool variationSize,
    required bool variationColor,
    required bool variationCapacity,
    required bool variationType,
    required bool variationWeight,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/categories');

    var responseData = await http.post(uri, headers: {
      "Accept": 'application/json',
      'Authorization': await getAuthToken(),
    }, body: {
      'categoryName': name,
      'variationSize': variationSize.toString(),
      'variationColor': variationColor.toString(),
      'variationCapacity': variationCapacity.toString(),
      'variationType': variationType.toString(),
      'variationWeight': variationWeight.toString(),
    });

    try {
      // final response = await request.send();
      // final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
        var data1 = ref.refresh(categoryProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }
  Future<void> editCategory({
    required WidgetRef ref,
    required BuildContext context,
    required num id,
    required String name,
    required bool variationSize,
    required bool variationColor,
    required bool variationCapacity,
    required bool variationType,
    required bool variationWeight,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/categories/$id');

    var responseData = await http.post(uri, headers: {
      "Accept": 'application/json',
      'Authorization': await getAuthToken(),
    }, body: {
      '_method': 'put',
      'categoryName': name,
      'variationSize': variationSize.toString(),
      'variationColor': variationColor.toString(),
      'variationCapacity': variationCapacity.toString(),
      'variationType': variationType.toString(),
      'variationWeight': variationWeight.toString(),
    });

    try {
      // final response = await request.send();
      // final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
        var data1 = ref.refresh(categoryProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  Future<bool> deleteCategory({required BuildContext context, required num categoryId}) async {
    final String apiUrl = '${APIConfig.url}/categories/$categoryId'; // Replace with your API URL

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': await getAuthToken(),
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category.')),
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
