import 'package:flutter_test/flutter_test.dart';
import 'package:gweatherforecast/resource/service/weather_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const cacheKey1 = "weather_hanoi";
  const cacheKey2 = "weather_hcm";

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await WeatherCacheService.clearHistory();
  });

  group('WeatherCacheService Tests', () {
    test('Save and load cache in the same day', () async {
      final data = {"temp": 30, "city": "Hanoi"};

      await WeatherCacheService.saveHistory(key: cacheKey1, data: data);
      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);

      expect(loaded, isNotNull);
      expect(loaded!["temp"], 30);
      expect(loaded["city"], "Hanoi");
    });

    test('Save then change date -> cache should be cleared', () async {
      final data = {"temp": 25, "city": "HCM"};
      await WeatherCacheService.saveHistory(key: cacheKey1, data: data);

      // Giả lập ngày hôm qua
      final prefs = await SharedPreferences.getInstance();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
      await prefs.setString(WeatherCacheService.dateKey, yesterdayStr);

      // Gọi load sẽ tự động clear
      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);
      expect(loaded, isNull);

      // Kiểm tra prefs đã xóa dateKey
      final afterClearDate = prefs.getString(WeatherCacheService.dateKey);
      expect(afterClearDate, isNull);
    });

    test('Load without saving anything returns null', () async {
      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);
      expect(loaded, isNull);
    });

    test('ClearHistory manually should clear all cache and prefs', () async {
      final data = {"temp": 28, "city": "Da Nang"};
      await WeatherCacheService.saveHistory(key: cacheKey1, data: data);

      await WeatherCacheService.clearHistory();

      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);
      expect(loaded, isNull);

      final prefs = await SharedPreferences.getInstance();
      final date = prefs.getString(WeatherCacheService.dateKey);
      expect(date, isNull);
    });

    test('Save multiple keys in the same day -> load separately', () async {
      final data1 = {"temp": 30, "city": "Hanoi"};
      final data2 = {"temp": 32, "city": "HCM"};

      await WeatherCacheService.saveHistory(key: cacheKey1, data: data1);
      await WeatherCacheService.saveHistory(key: cacheKey2, data: data2);

      final loaded1 = await WeatherCacheService.loadHistory(key: cacheKey1);
      final loaded2 = await WeatherCacheService.loadHistory(key: cacheKey2);

      expect(loaded1!["city"], "Hanoi");
      expect(loaded2!["city"], "HCM");
    });

    test('Save then clearHistory -> load should return null', () async {
      final data = {"temp": 35, "city": "Hue"};
      await WeatherCacheService.saveHistory(key: cacheKey1, data: data);

      await WeatherCacheService.clearHistory();

      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);
      expect(loaded, isNull);
    });

    test('Date mismatch automatically clears cache and resets SharedPreferences', () async {
      final data = {"temp": 29, "city": "Hai Phong"};
      await WeatherCacheService.saveHistory(key: cacheKey1, data: data);

      // Giả lập sang ngày khác
      final prefs = await SharedPreferences.getInstance();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowStr = "${tomorrow.year}-${tomorrow.month}-${tomorrow.day}";
      await prefs.setString(WeatherCacheService.dateKey, tomorrowStr);

      final loaded = await WeatherCacheService.loadHistory(key: cacheKey1);
      expect(loaded, isNull);

      // Kiểm tra prefs đã reset
      final afterClearDate = prefs.getString(WeatherCacheService.dateKey);
      expect(afterClearDate, isNull);
    });
  });
}
