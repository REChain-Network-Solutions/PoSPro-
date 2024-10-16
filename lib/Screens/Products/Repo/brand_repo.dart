//ignore_for_file: unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';
import '../Model/brands_model.dart';
import '../Providers/category,brans,units_provide.dart';

class BrandsRepo {
  Future<List<Brand>> fetchAllBrands() async {
    final uri = Uri.parse('${APIConfig.url}/brands');

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': await getAuthToken(),
      });

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body) as Map<String, dynamic>;
        final categoryList = parsedData['data'] as List<dynamic>;
        return categoryList.map((category) => Brand.fromJson(category)).toList();
      } else {
        throw Exception('Failed to fetch brands: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addBrand({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/brands');

    try {
      var responseData = await http.post(uri, headers: {
        "Accept": 'application/json',
        'Authorization': await getAuthToken(),
      }, body: {
        'brandName': name,
      });
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successful!')));
        var data1 = ref.refresh(brandsProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Brand creation failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  ///_________Edit_brand_________________________
  Future<void> editBrand({
    required WidgetRef ref,
    required BuildContext context,
    required num id,
    required String name,
  }) async {
    final uri = Uri.parse('${APIConfig.url}/brands/$id');

    try {
      var responseData = await http.post(uri, headers: {
        "Accept": 'application/json',
        'Authorization': await getAuthToken(),
      }, body: {
        'brandName': name,
        '_method': 'put',
      });
      final parsedData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update successful!')));
        var data1 = ref.refresh(brandsProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Brand update failed: ${parsedData['message']}')));
      }
    } catch (error) {
      // Handle unexpected errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  ///_________delete_brand________________________
  Future<bool> deleteBrand({required BuildContext context, required num brandId}) async {
    final String apiUrl = '${APIConfig.url}/brands/$brandId'; // Replace with your API URL

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
          SnackBar(content: Text('Failed to delete brand.')),
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
