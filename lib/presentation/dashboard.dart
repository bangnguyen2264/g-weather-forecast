// weather_dashboard.dart
import 'package:flutter/material.dart';
import 'package:gweatherforecast/resource/widget/email_subscription_dialog.dart';
import 'package:gweatherforecast/presentation/weather_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gweatherforecast/data/mock.dart';
import 'package:gweatherforecast/resource/widget/current_weather_card.dart';
import 'package:gweatherforecast/resource/widget/forecast_card.dart';
import 'package:gweatherforecast/resource/widget/search_box.dart';

class WeatherDashboard extends StatelessWidget {
  const WeatherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            automaticallyImplyLeading: false ,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: const Text(
              "Weather Dashboard",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.email_outlined),
                tooltip: "Subscribe for Email Forecasts",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailSubscriptionDialog(),
                  );
                },
              ),
            ],
            centerTitle: true,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              if (viewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (isMobile) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBox(),
                      const SizedBox(height: 16),
                      if (viewModel.currentWeather != null && viewModel.location != null)
                        CurrentWeatherCard(
                          weather: viewModel.currentWeather!,
                          location: viewModel.location!,
                        )
                      else
                        const SizedBox.shrink(),

                      if (viewModel.forecast != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "4-Day Forecast",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: (viewModel.forecast!).map((day) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 150,
                                maxWidth: constraints.maxWidth,
                              ),
                              child: ForecastCard(day: day),
                            );
                          }).toList(),
                        ),
                      ],
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: SearchBox(),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewModel.currentWeather != null && viewModel.location != null)
                              CurrentWeatherCard(
                                weather: viewModel.currentWeather!,
                                location: viewModel.location!,
                              )
                            else
                              const SizedBox.shrink(),
                            const SizedBox(height: 24),
                            const Text(
                              "4-Day Forecast",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            if (viewModel.forecast != null)
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: (viewModel.forecast!).map((day) {
                                  double cardWidth;
                                  if (isMobile) {
                                    cardWidth = constraints.maxWidth;
                                  } else if (isTablet) {
                                    cardWidth = constraints.maxWidth / 2;
                                  } else {
                                    cardWidth = constraints.maxWidth / 4;
                                  }

                                  return ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: 100, maxWidth: cardWidth),
                                    child: ForecastCard(day: day),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
