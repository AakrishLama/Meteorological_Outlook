import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/Model/location.dart';

class LocationNotifier extends StateNotifier<Location> {
  LocationNotifier() : super(Location(latitude: null, longitude: null));

  Future<void> getCurrentLocation() async {
    print("getCurrentLocation method started");
    try {
      // Request location permission
      PermissionStatus permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // Check if location services are enabled
        bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isLocationEnabled) {
          // setState(() {
          //   locationMessage = "Location services are disabled";
          // });
          state = state.copyWith(
            locationMessage: "Location services are disabled",
          );
        }

        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );

        // setState(() {
        //   latitude = position.latitude;
        //   longitude = position.longitude;
        //   locationMessage = "Latitude: ${latitude}, Longitude: ${longitude}";
        //   // print(locationMessage);
        // });
        state = state.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          locationMessage:
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
        );
        print(state.locationMessage);
      } else {
        // setState(() {
        //   locationMessage = "Permission denied in the processing for time";
        // });
        state = state.copyWith(
          locationMessage: "Permission denied in the processing for time",
        );
      }
    } catch (e) {
      // setState(() {
      //   locationMessage = "Error getting location: ${e.toString()}";
      // });
      state = state.copyWith(
        locationMessage: "Error getting location: ${e.toString()}",
      );
    }
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, Location>(
  (ref) => LocationNotifier(),
);
