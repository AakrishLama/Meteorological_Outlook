import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import "package:go_router/go_router.dart";
import 'package:intl/intl.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/Provider/Weather.dart';
import 'package:weather_app/widgets/input.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class MyLocation extends ConsumerStatefulWidget {
  const MyLocation({super.key});

  @override
  ConsumerState<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends ConsumerState<MyLocation> {
  TextEditingController addressController = TextEditingController();
  bool _isLoading = false;
  String _output = "";

  void submit() async {
    // print("submit");
    try {
      final location = await locationFromAddress(addressController.text);
      setState(() {
        _output = location.isNotEmpty
            ? location[0].toString()
            : 'No results found.';
        addressController.clear();
      });
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }

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
  void initState() {
    super.initState();
    fetchGeoLocation();
  }


  /// Build method for ui rendering.
  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      appBar: Appbar(heading: 'Home'),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // input field for address from input widget.
                Input(inputController: addressController, onSubmit: submit),
                const SizedBox(height: 20),


                if (_output != "") Text(_output),
                const SizedBox(height: 20),

                // condition check for loading location
                if (_isLoading) const CircularProgressIndicator(),
                if (locationState.locationMessage != null &&
                    locationState.latitude != null &&
                    locationState.longitude != null)
                  Column(
                    children: [
                      Text(locationState.locationMessage!), // location message
                    ],
                  ),

                const SizedBox(height: 20),
                // condition check for loading weather
                weatherAsync.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Text("");
                    }
                    // print(data.runtimeType); JSON now
                    return Text("""  
                      name: ${data['name']}, ${data['sys']['country']}
                      ${DateFormat.yMMMMEEEEd().format(DateTime.now())}
                      description: ${data['weather'][0]['description']}
                      Temp: ${data['main']['temp'].toStringAsFixed(2)}
                          Humidity: ${data['main']['humidity'].toStringAsFixed(2)}
                          Pressure: ${data['main']['pressure'].toStringAsFixed(2)}
                          Wind Speed: ${data['wind']['speed'].toStringAsFixed(2)}
                    """);
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
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
