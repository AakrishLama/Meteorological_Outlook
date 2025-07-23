import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatelessWidget {
  double? latitude;
  double? longitude;
  String? weatherInfo;
  String? api = "2548a9dcb20e6e423be61093728b306d";

  Weather({super.key, this.latitude, this.longitude, this.weatherInfo});

  Future<void> getWeatherInfo() async {
    if (latitude == null || longitude == null) {
      weatherInfo = "coordinates not found";

      return;
    }
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$api";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      weatherInfo = response.body;
    } else {
      weatherInfo = "Error getting weather info";
    }
    // print("weatherInfo: $weatherInfo (${weatherInfo.runtimeType})");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Weather")));
  }
}
