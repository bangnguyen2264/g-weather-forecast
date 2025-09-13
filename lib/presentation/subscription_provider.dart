import 'package:flutter/foundation.dart';
import 'package:gweatherforecast/resource/service/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();

  bool isLoading = false;
  bool isSubscribed = false;
  bool isSubscribeMode = true; // mặc định subscribe mode
  String? errorMessage;

  /// Chuyển đổi chế độ
  void toggleMode() {
    isSubscribeMode = !isSubscribeMode;
    errorMessage = null; // reset lỗi khi đổi chế độ
    notifyListeners();
  }

  /// Đặt lỗi
  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  /// Subscribe
  Future<void> subscribe(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.subscribe(email);
      isSubscribed = true;
    } catch (e) {
      errorMessage = "Has error subscribing occurred or email already registered";
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Unsubscribe
  Future<void> unsubscribe(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.unsubscribe(email);
      isSubscribed = false;
    } catch (e) {
      errorMessage = "Error unsubscribing occurred or email not found";
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
