import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['API_URL'] ?? (throw Exception('API_URL not set in .env'));
}
