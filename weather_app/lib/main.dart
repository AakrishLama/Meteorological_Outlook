import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? locationMessage;

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentLocation();
  // }

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
        print(position ?? "Position is null");

        setState(() {
          locationMessage =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
          // print(locationMessage);
        });
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(locationMessage ?? "Fetching location..."),
              ElevatedButton(
                onPressed: (){
                  print("refresh button pressed");
                  getCurrentLocation();
                },
                child: const Text("Refresh Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
