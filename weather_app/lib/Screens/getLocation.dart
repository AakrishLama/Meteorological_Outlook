import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
import "package:go_router/go_router.dart";
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/footer.dart';

class MyLocation extends ConsumerStatefulWidget {
  const MyLocation({super.key});

  @override
  ConsumerState<MyLocation> createState() => _MyLocationState();

  //  @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(locationProvider.notifier).getCurrentLocation();
  //   });
  // }
}

class _MyLocationState extends ConsumerState<MyLocation> {

  String? locationMessage;
  // double? latitude;
  // double? longitude;
  String? weatherInfo;

  // Future<void> getCurrentLocation() async {
  //   print("getCurrentLocation method started");
  //   try {
  //     // Request location permission
  //     PermissionStatus permissionStatus = await Permission.location.request();

  //     if (permissionStatus.isGranted) {
  //       // Check if location services are enabled
  //       bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //       if (!isLocationEnabled) {
  //         setState(() {
  //           locationMessage = "Location services are disabled";
  //         });
  //         return;
  //       }

  //       // Get current position
  //       Position position = await Geolocator.getCurrentPosition(
  //         // ignore: deprecated_member_use
  //         desiredAccuracy: LocationAccuracy.high,
  //       );

  //       setState(() {
  //         latitude = position.latitude;
  //         longitude = position.longitude;
  //         locationMessage = "Latitude: ${latitude}, Longitude: ${longitude}";
  //         // print(locationMessage);
  //       });
  //       print("latitude: ${latitude}, mero longitude: ${longitude}");
  //     } else {
  //       setState(() {
  //         locationMessage = "Permission denied in the processing for time";
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       locationMessage = "Error getting location: ${e.toString()}";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final locationNotifier = ref.watch(locationProvider);

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
                 if (locationNotifier.locationMessage != null)
                  Text(locationNotifier.locationMessage!),
                if (locationNotifier.latitude != null)
                  Text("Lat: ${locationNotifier.latitude!.toStringAsFixed(4)}"),
                if (locationNotifier.longitude != null)
                  Text("Long: ${locationNotifier.longitude!.toStringAsFixed(4)}"),
                ElevatedButton(
                  onPressed: () {
                    print("refresh button pressed");
                    // calling the method from the provider to get location.
                    ref.read(locationProvider.notifier).getCurrentLocation();
                  },
                  child: const Text("Get my GeoLocation"),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("get weather info button pressed");
                    GoRouter.of(context).go(
                      "/weatherInfo?latitude=$locationNotifier.latitude&longitude=$locationNotifier.longitude",
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
            child: Footer(latitude: locationNotifier.latitude, longitude: locationNotifier.longitude),
          ),
        ],
      ),
    );
  }
}
