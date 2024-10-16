import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Const/api_config.dart';
import '../../model/business_category_model.dart';
import '../constant_functions.dart';

class BusinessCategoryRepository {
  Future<List<BusinessCategory>> getBusinessCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${APIConfig.url}${APIConfig.businessCategoriesUrl}'),
        headers: {
          'Authorization': 'Bearer ${await getAuthToken()}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((category) => BusinessCategory.fromJson(category)).toList();
      } else {

        throw Exception('Failed to fetch business categories');
      }
    } catch (error) {
      throw Exception('Error fetching business categories: $error');
    }
  }
}
