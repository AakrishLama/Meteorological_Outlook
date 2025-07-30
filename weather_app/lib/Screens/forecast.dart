import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Weather extends ConsumerStatefulWidget {
  const Weather({super.key});

  // final double? latitude;
  // final double? longitude;

  // const Weather({super.key, this.latitude, this.longitude});

  @override
  ConsumerState<Weather> createState() => _WeatherState();
}

class _WeatherState extends ConsumerState<Weather> {
  // Weather Info to display in the ui.
  String? weatherInfo;

  final String api = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    getWeatherInfo();
  }

  Future<void> getWeatherInfo() async {
    try {
      final locationState = ref.read(locationProvider);
      final lat = locationState.latitude;
      final lon = locationState.longitude;

      if (lat == null || lon == null) {
        throw Exception('Coordinates not available');
      }

      // Test DNS first
      await InternetAddress.lookup('api.openweathermap.org');

      final url = Uri.https('api.openweathermap.org', '/data/2.5/forecast', {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': dotenv.env['API_KEY'] ?? '',
      });

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('API request failed: ${response.statusCode}');
      }

      setState(() {
        weatherInfo = response.body;
        // print(weatherInfo);
      });
    } on SocketException catch (e) {
      setState(() {
        weatherInfo = 'Network error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(heading: 'Forecast',),
      body: weatherInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 5, // Show 5 days
                    itemBuilder: (context, dayIndex) {
                      // Parse your JSON data here
                      final jsonData = jsonDecode(weatherInfo!);
                      final forecasts = jsonData['list'] as List;

                      // Get forecasts for this day (8 forecasts per day)
                      final dayForecasts = forecasts
                          .skip(dayIndex * 8)
                          .take(8)
                          .toList();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, MMM d').format(
                                  DateTime.parse(dayForecasts.first['dt_txt']),
                                ),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dayForecasts.length,
                                  itemBuilder: (context, index) {
                                    final forecast = dayForecasts[index];
                                    final time = DateTime.parse(
                                      forecast['dt_txt'],
                                    );
                                    final temp = forecast['main']['temp'];
                                    final weather = forecast['weather'][0];

                                    return Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            DateFormat('HH:mm').format(time),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Image.network(
                                            'https://openweathermap.org/img/wn/${weather['icon']}@2x.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                          Text(
                                            '${(temp - 273.15).toStringAsFixed(1)}°C',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            weather['description'],
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Footer(),
              ],
            ),
    );
  }
}
