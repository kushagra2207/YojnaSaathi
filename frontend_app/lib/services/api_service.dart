import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/scheme.dart';
import '../models/health_notice.dart';

class ApiService {
  Future<List<Scheme>> fetchSchemes() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/api/schemes'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Scheme.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schemes: ${response.statusCode}');
    }
  }

  Future<List<HealthNotice>> fetchHealthNotices() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/api/health-notices'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => HealthNotice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load health notices: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchSyncLatest() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/api/sync/latest'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch sync info: ${response.statusCode}');
    }
  }
}
