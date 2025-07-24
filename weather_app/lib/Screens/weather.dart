import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/footer.dart';

class Weather extends ConsumerStatefulWidget {
  final double? latitude;
  final double? longitude;

  const Weather({super.key, this.latitude, this.longitude});

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
    final locationState = ref.read(locationProvider);
    final lat = locationState.latitude;
    final lon = locationState.longitude;

    // Check if latitude and longitude are null
    if (lat == null || lon == null) {
      setState(() {
        weatherInfo = "Coordinates not found";
      });
      return;
    }

    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=$api";

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
    final locationNotifier = ref.watch(locationProvider);
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
