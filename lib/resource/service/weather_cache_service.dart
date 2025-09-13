import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gweatherforecast/resource/utils/format_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherCacheService {
  static const dateKey = "weather_cache_date";

  /// Gọi ở app start để clear cache nếu đã qua ngày
  static Future<void> checkAndClearIfExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(dateKey); 
    final todayStr = formatDate(DateTime.now());

    if (lastDate != todayStr) {
      await clearHistory();
      await prefs.setString(dateKey, todayStr);
    }
  }

  static Future<void> saveHistory({required String key, required Map<String, dynamic> data}) async {
    final cacheManager = DefaultCacheManager();

    final jsonString = jsonEncode(data);

    await cacheManager.putFile(
      key,
      Uint8List.fromList(jsonString.codeUnits),
      fileExtension: "json",
    );
  }

  static Future<Map<String, dynamic>?> loadHistory({required String key}) async {
    print("Loading weather from cache with key: $key");
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(key);

    if (fileInfo == null) return null;

    final content = await fileInfo.file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  static Future<void> clearHistory() async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(dateKey);
    print("Cache cleared");
  }
}
