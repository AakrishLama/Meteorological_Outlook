import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/footer.dart';

class MyLocation extends ConsumerStatefulWidget {
  const MyLocation({super.key});

  @override
  ConsumerState<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends ConsumerState<MyLocation> {
  bool _isLoading = false;

  void fetchGeoLocation() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(locationProvider.notifier).getCurrentLocation();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

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
                if (_isLoading) const CircularProgressIndicator(),
                if (locationState.locationMessage != null &&
                    locationState.latitude != null &&
                    locationState.longitude != null)
                  Column(
                    children: [
                      Text(locationState.locationMessage!),
                      Text(
                        "Lat: ${locationState.latitude!.toStringAsFixed(4)}",
                      ),
                      Text(
                        "Long: ${locationState.longitude!.toStringAsFixed(4)}",
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: fetchGeoLocation,
                  child: const Text("Get my GeoLocation"),
                ),
                ElevatedButton(
                  onPressed:
                      locationState.latitude != null &&
                          locationState.longitude != null
                      ? () => GoRouter.of(context).go("/weatherInfo")
                      : null,
                  child: const Text("Get Weather Info"),
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
