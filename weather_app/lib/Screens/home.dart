import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import "package:go_router/go_router.dart";
import 'package:intl/intl.dart';
import 'package:weather_app/Model/saveLocation.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/Provider/Weather.dart';
import 'package:weather_app/Provider/savedLocation_provider.dart';
import 'package:weather_app/widgets/button.dart';
import 'package:weather_app/widgets/input.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class MyLocation extends ConsumerStatefulWidget {
  final double? lat;
  final double? long;
  const MyLocation({Key? key, this.lat, this.long}) : super(key: key);

  @override
  ConsumerState<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends ConsumerState<MyLocation> {
  TextEditingController addressController = TextEditingController();
  double? inputLat;
  double? inputLong;
  bool _isLoading = false;
  String _output = "";
  final Map<String, List<String>> weatherDiscription = {
    "clear sky": ["☀️", "assets/clearsky.jpeg"],
    "few clouds": ["🌤️", "assets/fewClouds.jpeg"],
    "scattered clouds": ["☁️", "assets/scatteredClouds.jpeg"],
    "broken clouds": ["🌥️", "assets/brokenClouds.jpeg"],
    "overcast clouds": ["🌥️", "assets/brokenClouds.jpeg"],

    "light rain": ["🌦️", "assets/Rain.jpeg"],
    "moderate rain": ["🌧️", "assets/Rain.jpeg"],
    "heavy intensity rain": ["🌧️", "assets/Rain.jpeg"],
    "shower rain": ["🌧️", "assets/showerRain.jpeg"],

    "thunderstorm": ["⛈️", "assets/thunderstorm.jpeg"],
    "thunderstorm with light rain": ["⛈️", "assets/thunderstorm.jpeg"],
    "thunderstorm with heavy rain": ["⛈️", "assets/thunderstorm.jpeg"],

    "light snow": ["🌨️", "assets/snow.jpeg"],
    "snow": ["❄️", "assets/snow.jpeg"],
    "heavy snow": ["❄️", "assets/snow.jpeg"],

    "mist": ["🌫️", "assets/mist.jpeg"],
    "fog": ["🌫️", "assets/mist.jpeg"],
    "haze": ["🌫️", "assets/mist.jpeg"],
    "smoke": ["🌫️", "assets/mist.jpeg"],
    "dust": ["🌫️", "assets/mist.jpeg"],
    "sand": ["🌫️", "assets/mist.jpeg"],
    "squalls": ["🌬️", "assets/mist.jpeg"],
    "tornado": ["🌪️", "assets/mist.jpeg"],

    "drizzle": ["🌧️", "assets/showerRain.jpeg"],
    "light intensity drizzle": ["🌦️", "assets/showerRain.jpeg"],
    "heavy intensity drizzle": ["🌧️", "assets/showerRain.jpeg"],
  };

  String backgroundImage = "assets/clearsky.jpeg";

  void submit() async {
    _isLoading = true;
    try {
      if (addressController.text.trim().isEmpty) {
        setState(() {
          _output = 'Please enter an address.';
          _isLoading = false;
        });
        return;
      }
      final locations = await locationFromAddress(addressController.text);
      setState(() {
        if (locations.isEmpty) {
          _output = "No results found";
        } else {
          final location = locations[0];
          inputLat = location.latitude;
          inputLong = location.longitude;
          _output = locations[0].toString();
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
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  int kelvinToCelsius(double k) {
    k = k - 273.15;
    return k.toInt();
  }

  @override
  void initState() {
    super.initState();
    // If lat and long are provided from route.
    if (widget.lat != null && widget.long != null) {
      inputLat = widget.lat;
      inputLong = widget.long;
    }
    fetchGeoLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final currentLat = inputLat ?? locationState.latitude;
    final currentLong = inputLong ?? locationState.longitude;

    final weatherAsync = (currentLat != null && currentLong != null)
        ? ref.watch(weatherProvider((currentLat, currentLong)))
        : const AsyncValue.loading();

    final watchlist = ref.watch(savedLocationProvider);

    void watchList(BuildContext context, data) {
      ref
          .read(savedLocationProvider.notifier)
          .addLocation(
            SaveLocation(
              name: data['name'],
              latitude: currentLat!,
              longitude: currentLong!,
              description: data['weather'][0]['description'],
              high: kelvinToCelsius(data['main']['temp_max']),
              low: kelvinToCelsius(data['main']['temp_min']),
              temp: kelvinToCelsius(data["main"]["temp"]),
              country: data['sys']['country'],
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location added to watchlist')),
      );
    }

    weatherAsync.whenData((data) {
      if (data.isNotEmpty) {
        final desc = data['weather'][0]['description'];
        if (weatherDiscription.containsKey(desc)) {
          backgroundImage = weatherDiscription[desc]![1]; // Get image path
        }
      }
    });

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: Appbar(heading: 'Weather App'),
          body: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Input(inputController: addressController, onSubmit: submit),
                    const SizedBox(height: 20),

                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (_output.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_output, style: TextStyle(fontSize: 16)),
                      )
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

                    const SizedBox(height: 20),

                    weatherAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Text("");
                        }

                        return Column(
                          children: [
                            Text("""
                        name: ${data['name']}, ${data['sys']['country']}
                        ${DateFormat.yMMMMEEEEd().format(DateTime.now())}
                        description: ${data['weather'][0]['description']}
                        Temperature: ${kelvinToCelsius(data["main"]["temp"])} °C
                        Humidity: ${data['main']['humidity'].toStringAsFixed(2)}
                        Pressure: ${data['main']['pressure'].toStringAsFixed(2)}
                        Wind Speed: ${data['wind']['speed'].toStringAsFixed(2)}
                        latitude: ${currentLat}    
                        longitude: ${currentLong}  
                        high: ${kelvinToCelsius(data['main']['temp_max'])}
                        low: ${kelvinToCelsius(data['main']['temp_min'])}
                      """),
                            const SizedBox(height: 20),
                            Button(
                              text: 'Add',
                              onPressed: () => watchList(context, data),
                              icon: Icons.add,
                            ),
                          ],
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Footer(currentLat, currentLong),
        ),
      ],
    );
  }
}
