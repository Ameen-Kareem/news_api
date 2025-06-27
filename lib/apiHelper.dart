import 'package:http/http.dart' as http;
import 'package:news_api/appConfig.dart';

class Apihelper {
  static Future<http.Response> fetchGetApiHelper({
    required String endpoint,
  }) async {
    final url = Uri.parse(Appconfig.baseUrl + endpoint);
    final response = await http.get(url);
    return response;
  }
}
