import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Provider/Location_provider.dart';
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

      final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
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
        print(weatherInfo);
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
    // final locationNotifier = ref.watch(locationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather Info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weatherInfo ?? "Loading..."),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go("/"),
                  child: const Text("Go back"),
                ),
              ],
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: Footer()),
        ],
      ),
    );
  }
}
