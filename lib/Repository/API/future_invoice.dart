import 'package:http/http.dart' as http;

import '../../Const/api_config.dart';
import '../constant_functions.dart';

class FutureInvoice {
  Future<String> getFutureInvoice({required String tag}) async {
    try {
      final response = await http.get(
        Uri.parse('${APIConfig.url}/new-invoice?platform=$tag'),
        headers: {
          'Authorization': 'Bearer ${await getAuthToken()}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
    } catch (error) {
      return '';
    }
  }
}
