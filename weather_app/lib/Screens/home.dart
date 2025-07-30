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
    _isLoading = true;
    try {
      if (addressController.text.trim().isEmpty) {
        setState(() {
          _output = 'Please enter an address.';
          _isLoading = false;
        });
        return;
      }
      final location = await locationFromAddress(addressController.text);
      setState(() {
        if(location.isEmpty){
          _output = "No results found";
        }else{
          _output = location[0].toString();
        }
        addressController.clear();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
        _isLoading = false;
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

                // condition check for loading location
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_output.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_output, style: TextStyle(fontSize: 16)),
                  )
                // else if (locationState.locationMessage != null &&
                //   locationState.latitude != null &&
                //   locationState.longitude != null)
                // Column(
                //   children: [
                //     Text(locationState.locationMessage!), // location message
                //   ],
                else
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locationState.locationMessage!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                // if(_output.isEmpty)
                //   if (_isLoading) const CircularProgressIndicator(),
                // else if (_output.isNotEmpty) Text(_output),

                // if (_isLoading) const CircularProgressIndicator(),
                // if (locationState.locationMessage != null &&
                //     locationState.latitude != null &&
                //     locationState.longitude != null)
                //   Column(
                //     children: [
                //       Text(locationState.locationMessage!), // location message
                //     ],
                //   ),
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
                          latitude: ${locationState.latitude}
                          longitude: ${locationState.longitude}
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
