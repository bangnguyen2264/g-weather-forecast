import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gweatherforecast/firebase_options.dart';
import 'package:gweatherforecast/presentation/dashboard.dart';
import 'package:gweatherforecast/presentation/search_viewmodel.dart';
import 'package:gweatherforecast/presentation/subscription_provider.dart';
import 'package:gweatherforecast/presentation/verify_page.dart';
import 'package:gweatherforecast/presentation/weather_viewmodel.dart';
import 'package:gweatherforecast/resource/service/weather_cache_service.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  // Sử dụng path-based URL (loại bỏ #)
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await WeatherCacheService.checkAndClearIfExpired();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'G-Weather-Forecast',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Rubik'),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // In ra settings.name để debug
        print('Settings name: ${settings.name}');

        // Parse URI và chuẩn hóa path
        final uri = Uri.parse(settings.name ?? '/');
        String path = uri.path.isNotEmpty ? uri.path : '/';

        // Loại bỏ dấu / thừa ở đầu hoặc cuối
        path = path.replaceAll(RegExp(r'^/+|/+$'), '');

        print('Parsed URI: $uri, Path: $path');

        if (path == 'verify') {
          final token = uri.queryParameters['token'] ?? '';
          print('Navigating to VerifyPage with token: $token');
          return MaterialPageRoute(builder: (_) => VerifyPage(token: token));
        }

        print('Navigating to WeatherDashboard');
        return MaterialPageRoute(builder: (_) => const WeatherDashboard());
      },
    );
  }
}
