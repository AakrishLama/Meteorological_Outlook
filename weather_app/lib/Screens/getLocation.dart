import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:go_router/go_router.dart";
import 'package:weather_app/widgets/footer.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Info", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Main content column
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locationMessage ?? "Get the location by clicking the button",
                ),
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
                    GoRouter.of(context).go(
                      "/weatherInfo?latitude=$latitude&longitude=$longitude",
                    );
                  },
                  child: const Text("Get Weather Info"),
                ),
              ],
            ),
          ),

          // Footer positioned at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Footer(latitude: latitude, longitude: longitude),
          ),
        ],
      ),
    );
  }
}
