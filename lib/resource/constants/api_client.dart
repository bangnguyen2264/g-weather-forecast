import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiClient {
  // static String apiUrl = dotenv.env['BASE_URL'] ?? '';
  // static String verifyServer = dotenv.env['VERIFY_SERVER'] ?? '';
  // static String apiKey = dotenv.env['API_KEY'] ?? '';
  static String apiKey = String.fromEnvironment('API_KEY');
  static String apiUrl = String.fromEnvironment('API_URL');
  static String verifyServer = String.fromEnvironment('VERIFY_SERVER');
  static const String forecastEndpoint = '/forecast.json';
  static const String searchEndpoint = '/search.json';
}

