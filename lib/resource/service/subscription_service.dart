import 'package:gweatherforecast/resource/constants/api_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  /// Đăng ký và gửi email xác thực
  Future<void> subscribe(String email) async {
    final _pref = await SharedPreferences.getInstance();
    try {
      final currentLocation = _pref.getString('current_location') ?? '';
      print('Sending activation email to: $email');
      final response = await http.post(
        Uri.parse(
          '${ApiClient.verifyServer}/api/v1/verify/send-activation?email=$email&location=$currentLocation',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send activation email: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending activation email: $e');
    }
  }

  Future<void> unsubscribe(String email) async {
    try {
      print('Unsubscribing email: $email');
      final response = await http.post(
        Uri.parse('${ApiClient.verifyServer}/api/v1/verify/unsubscribe?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Unsubscribe response status: ${response.statusCode}, body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to unsubscribe: ${response.body}');
      }
    } catch (e) {
      print('Error unsubscribing: $e');
      throw Exception('Error unsubscribing: $e');
    }
  }

  /// Xác nhận email dựa trên token
  Future<bool> confirmEmail(String token) async {
    try {
      final url = Uri.parse('${ApiClient.verifyServer}/api/v1/verify/activate?token=$token');
      print('Verifying token: $url  '); // Debug token value
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('Email verified successfully with response: ${response.body}'); // Debug success
        return true;
      } else {
        print('Failed to verify email: ${response.body}'); // Debug failure
        return false;
      }
    } catch (e) {
      throw Exception('Error verifying email: $e');
    }
  }
}
