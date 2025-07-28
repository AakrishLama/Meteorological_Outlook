import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:intl/intl.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/Provider/Weather.dart';
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
    final weatherAsync = ref.watch(weatherProvider);
    

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
                const SizedBox(height: 20),
                weatherAsync.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Text("");
                    }
                    // print(data.runtimeType); JSON now
                    return Text(
                      """  
                      name: ${data['name']}, ${data['sys']['country']}
                      ${DateFormat.yMMMMEEEEd().format(DateTime.now())}
                      description: ${data['weather'][0]['description']}
                      Temp: ${data['main']['temp'].toStringAsFixed(2)}
                          Humidity: ${data['main']['humidity'].toStringAsFixed(2)}
                          Pressure: ${data['main']['pressure'].toStringAsFixed(2)}
                          Wind Speed: ${data['wind']['speed'].toStringAsFixed(2)}
                    """,
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                ),

                // ElevatedButton(
                //   onPressed:
                //       locationState.latitude != null &&
                //           locationState.longitude != null
                //       ? () => GoRouter.of(context).go("/weatherInfo")
                //       : null,
                //   child: const Text(" Forecast"),
                // ),
              ],
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: Footer()),
        ],
      ),
    );
  }
}
