import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:weather_app/Model/dailyForecast.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Weather extends ConsumerStatefulWidget {
  final double? inputLat;
  final double? inputLong;

  Weather(this.inputLat, this.inputLong, {super.key});

  @override
  ConsumerState<Weather> createState() => _WeatherState();
}

class _WeatherState extends ConsumerState<Weather> {
  Map<String, dynamic>? weatherInfo;
  List<DailyForecast> dailyWeather = [];

  final String api = dotenv.env['API_KEY'] ?? '';

  final Map<String, List<String>> weatherDiscription = {
    "clear sky": ["assets/clearsky.json", "assets/clearsky.jpeg"],
    "few clouds": ["assets/fewClouds.json", "assets/fewClouds.jpeg"],
    "scattered clouds": [
      "assets/scatteredClouds.json",
      "assets/scatteredClouds.jpeg",
    ],
    "broken clouds": ["assets/brokenClouds.json", "assets/brokenClouds.jpeg"],
    "overcast clouds": ["assets/brokenClouds.json", "assets/brokenClouds.jpeg"],
    "light rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "moderate rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "heavy intensity rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "shower rain": ["assets/showerRain.json", "assets/showerRain.jpeg"],
    "thunderstorm": ["assets/thunderstorm.json", "assets/thunderstorm.jpeg"],
    "thunderstorm with light rain": [
      "assets/thunderstorm.json",
      "assets/thunderstorm.jpeg",
    ],
    "thunderstorm with heavy rain": [
      "assets/thunderstorm.json",
      "assets/thunderstorm.jpeg",
    ],
    "light snow": ["assets/snow.json", "assets/snow.jpeg"],
    "snow": ["assets/snow.json", "assets/snow.jpeg"],
    "heavy snow": ["assets/snow.json", "assets/snow.jpeg"],
    "mist": ["assets/mist.json", "assets/mist.jpeg"],
    "fog": ["assets/mist.json", "assets/mist.jpeg"],
    "haze": ["assets/mist.json", "assets/mist.jpeg"],
    "smoke": ["assets/mist.json", "assets/mist.jpeg"],
    "dust": ["assets/mist.json", "assets/mist.jpeg"],
    "sand": ["assets/mist.json", "assets/mist.jpeg"],
    "squalls": ["assets/mist.json", "assets/mist.jpeg"],
    "tornado": ["assets/mist.json", "assets/mist.jpeg"],
    "drizzle": ["assets/showerRain.json", "assets/showerRain.jpeg"],
    "light intensity drizzle": [
      "assets/showerRain.json",
      "assets/showerRain.jpeg",
    ],
    "heavy intensity drizzle": [
      "assets/showerRain.json",
      "assets/showerRain.jpeg",
    ],
  };

  @override
  void initState() {
    super.initState();
    getWeatherInfo();
  }

  Future<void> getWeatherInfo() async {
    double? lat;
    double? lon;
    try {
      if (widget.inputLat != null || widget.inputLong != null) {
        lat = widget.inputLat;
        lon = widget.inputLong;
      } else {
        final locationState = ref.read(locationProvider);
        lat = locationState.latitude;
        lon = locationState.longitude;
      }

      await InternetAddress.lookup('api.openweathermap.org');

      final url = Uri.https('api.openweathermap.org', '/data/2.5/forecast', {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': api,
        'units': 'metric', 
      });

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('API request failed: ${response.statusCode}');
      }

      setState(() {
        weatherInfo = jsonDecode(response.body);
        dailyWeather = _groupByDay(weatherInfo!['list']);
      });
    } on SocketException catch (e) {
      setState(() {
        weatherInfo = {"error": 'Network error: ${e.message}'};
      });
    } catch (e) {
      setState(() {
        weatherInfo = {"error": 'Error: $e'};
      });
    }
  }

  List<DailyForecast> _groupByDay(List<dynamic> forecasts) {
    final Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var forecast in forecasts) {
      final date = forecast['dt_txt'].toString().split(' ')[0];

      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(forecast as Map<String, dynamic>);
    }

    return groupedData.entries.map((entry) {
      final date = entry.key;
      final dayForecasts = entry.value;

      return DailyForecast(
        date: date,
        day: DateFormat('EEEE').format(DateTime.parse(date)),
        forecasts: dayForecasts,
        minTemp: _findMinTemp(dayForecasts),
        maxTemp: _findMaxTemp(dayForecasts),
        description: dayForecasts[0]['weather'][0]['description'],
      );
    }).toList();
  }

  double _findMinTemp(List<dynamic> dayForecasts) {
    double min = double.infinity;
    for (var forecast in dayForecasts) {
      final temp = (forecast['main']['temp'] as num).toDouble();
      if (temp < min) min = temp;
    }
    return min;
  }

  double _findMaxTemp(List<dynamic> dayForecasts) {
    double max = -double.infinity;
    for (var forecast in dayForecasts) {
      final temp = (forecast['main']['temp'] as num).toDouble();
      if (temp > max) max = temp;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: Appbar(heading: 'Weather'),
        body: weatherInfo == null
            ? const Center(child: CircularProgressIndicator())
            : dailyWeather.isEmpty
            ? const Center(child: Text("No forecast data available."))
            : ListView.builder(
                itemCount: dailyWeather.length,
                itemBuilder: (context, index) {
                  final day = dailyWeather[index];
                  final forecasts = day.forecasts;
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${day.day}, ${day.date}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: forecasts.length,
                            itemBuilder: (context, forecastIndex) {
                              final forecast = forecasts[forecastIndex];
                              final time = forecast['dt_txt']
                                  .split(' ')[1]
                                  .substring(0, 5);
                              final description =
                                  forecast['weather'][0]['description']
                                      .toString()
                                      .toLowerCase();
      
                              // Get JSON animation file, fallback to default if missing
                              final jsonFile =
                                  weatherDiscription[description]?.first ??
                                  'assets/clearsky.json';
      
                              final temp = (forecast['main']['temp'] as num)
                                  .toDouble();
      
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      time,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Lottie.asset(
                                        jsonFile,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      '${temp.toStringAsFixed(1)}°C',
                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                    ),
                                    Text(
                                      description,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10, color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: const Footer(null, null),
      ),
    );
  }
}
