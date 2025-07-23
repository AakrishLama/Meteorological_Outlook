import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MyLocation extends StatefulWidget {
  const MyLocation({super.key});

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  String? locationMessage;
  double? latitude;
  double? longitude;
  String? weatherInfo;
  String? api = "2548a9dcb20e6e423be61093728b306d";

  Future<void> getCurrentLocation() async {
    print("getCurrentLocation method started");
    try {
      // Request location permission
      PermissionStatus permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // Check if location services are enabled
        bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isLocationEnabled) {
          setState(() {
            locationMessage = "Location services are disabled";
          });
          return;
        }

        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          locationMessage = "Latitude: ${latitude}, Longitude: ${longitude}";
          // print(locationMessage);
        });
        print("latitude: ${latitude}, mero longitude: ${longitude}");
      } else {
        setState(() {
          locationMessage = "Permission denied in the processing for time";
        });
      }
    } catch (e) {
      setState(() {
        locationMessage = "Error getting location: ${e.toString()}";
      });
    }
  }

  Future<void> getWeatherInfo() async {
    if (latitude == null || longitude == null) {
        weatherInfo = "coordinates not found";

      return;
    }
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$api";
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
    print("weatherInfo: $weatherInfo (${weatherInfo.runtimeType})");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage ?? "Get the location by clicking the button"),
            ElevatedButton(
              onPressed: () {
                print("refresh button pressed");
                getCurrentLocation();
              },
              child: const Text("Refresh Location"),
            ),
            ElevatedButton(
              onPressed: () {
                print("get weather info button pressed");
                getWeatherInfo();
              },
              child: const Text("Get Weather Info"),
            ),
          ],
        ),
      ),
    );
  }
}
