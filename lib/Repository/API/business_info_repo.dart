import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/model/dashboard_overview_model.dart';
import 'package:mobile_pos/model/todays_summary_model.dart';

import '../../model/business_info_model.dart';
import '../constant_functions.dart';

class BusinessRepository {
  Future<BusinessInformation> fetchBusinessData() async {
    final uri = Uri.parse('${APIConfig.url}/business');
    final token = await getAuthToken(); // Replace with your token retrieval logic

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Assuming Bearer token format
    });
    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);
      return BusinessInformation.fromJson(parsedData['data']); // Extract the "data" object from the response
    } else {
      // await LogOutRepo().signOut();

      throw Exception('Failed to fetch business data');
    }
  }

  Future<BusinessInformation?> checkBusinessData() async {
    final uri = Uri.parse('${APIConfig.url}/business');
    final token = await getAuthToken(); // Replace with your token retrieval logic

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Assuming Bearer token format
    });
    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);
      return BusinessInformation.fromJson(parsedData['data']); // Extract the "data" object from the response
    } else {
      return null;
    }
  }

  Future<TodaysSummaryModel> fetchTodaySummaryData() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final uri = Uri.parse('${APIConfig.url}/summary?date=$date');
    final token = await getAuthToken(); // Replace with your token retrieval logic

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Assuming Bearer token format
    });
    if (response.statusCode == 200) {
      print(response.body);
      return TodaysSummaryModel.fromJson(jsonDecode(response.body)); // Extract the "data" object from the response
    } else {
      // await LogOutRepo().signOut();

      throw Exception('Failed to fetch business data');
    }
  }

  Future<DashboardOverviewModel> dashboardData(String type) async {
    final uri = Uri.parse('${APIConfig.url}/dashboard?duration=$type');
    final token = await getAuthToken(); // Replace with your token retrieval logic

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Assuming Bearer token format
    });
    if (response.statusCode == 200) {
      print(response.body);
      return DashboardOverviewModel.fromJson(jsonDecode(response.body)); // Extract the "data" object from the response
    } else {
      // await LogOutRepo().signOut();

      throw Exception('Failed to fetch business data ${response.statusCode}');
    }
  }

}
