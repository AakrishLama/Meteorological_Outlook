import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const Weather({super.key, this.latitude, this.longitude});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String? weatherInfo;
  final String api = "2548a9dcb20e6e423be61093728b306d";

  @override
  void initState() {
    super.initState();
    getWeatherInfo();
  }

  Future<void> getWeatherInfo() async {
    if (widget.latitude == null || widget.longitude == null) {
      setState(() {
        weatherInfo = "Coordinates not found";
      });
      return;
    }

    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${widget.latitude}&lon=${widget.longitude}&appid=$api";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        weatherInfo = response.body;
      });
    } else {
      setState(() {
        weatherInfo = "Error getting weather info";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Info", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weatherInfo ?? "Loading..."),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go("/");
              },
              child: const Text("Go back"),
            ),
          ],
        ),
      ),
    );
  }
}
