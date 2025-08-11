import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import "package:go_router/go_router.dart";
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Model/saveLocation.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/Provider/Weather.dart';
import 'package:weather_app/Provider/savedLocation_provider.dart';
import 'package:weather_app/widgets/button.dart';
import 'package:weather_app/widgets/input.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';
import 'package:weather_app/widgets/weatherCard.dart';
import 'package:weather_app/widgets/weatherDetail.dart';

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
    "clear sky": ["assets/clearsky.json", "assets/clearsky.jpeg"],
    "few clouds": ["assets/fewClouds.json", "assets/fewClouds.jpeg"],
    "scattered clouds": [
      "assets/scatteredClouds.json",
      "assets/scatteredClouds.jpeg",
    ],
    "broken clouds": ["assets/brokenClouds.json", "assets/brokenClouds.jpeg"],
    "overcast clouds": ["assets/brokenClouds.json", "assets/brokenClouds.jpeg"],

    "light rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "moderate rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "heavy intensity rain": ["assets/rain.json", "assets/Rain.jpeg"],
    "shower rain": ["assets/showerRain.json", "assets/showerRain.jpeg"],

    "thunderstorm": ["assets/thunderstorm.json", "assets/thunderstorm.jpeg"],
    "thunderstorm with light rain": [
      "assets/thunderstorm.json",
      "assets/thunderstorm.jpeg",
    ],
    "thunderstorm with heavy rain": [
      "assets/thunderstorm.json",
      "assets/thunderstorm.jpeg",
    ],

    "light snow": ["assets/snow.json", "assets/snow.jpeg"],
    "snow": ["assets/snow.json", "assets/snow.jpeg"],
    "heavy snow": ["assets/snow.json", "assets/snow.jpeg"],

    "mist": ["assets/mist.json", "assets/mist.jpeg"],
    "fog": ["assets/mist.json", "assets/mist.jpeg"],
    "haze": ["assets/mist.json", "assets/mist.jpeg"],
    "smoke": ["assets/mist.json", "assets/mist.jpeg"],
    "dust": ["assets/mist.json", "assets/mist.jpeg"],
    "sand": ["assets/mist.json", "assets/mist.jpeg"],
    "squalls": ["assets/mist.json", "assets/mist.jpeg"],
    "tornado": ["assets/mist.json", "assets/mist.jpeg"],

    "drizzle": ["assets/showerRain.json", "assets/showerRain.jpeg"],
    "light intensity drizzle": [
      "assets/showerRain.json",
      "assets/showerRain.jpeg",
    ],
    "heavy intensity drizzle": [
      "assets/showerRain.json",
      "assets/showerRain.jpeg",
    ],
  };

  String backgroundImage = "assets/clearsky.jpeg";
  String animation = "assets/thunderstorm.json";

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

  int kelvinToCelsius(num k) {
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
              backgroundImage: backgroundImage,
            ),
          );
      Fluttertoast.showToast(
        msg: "Location added to watchlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    weatherAsync.whenData((data) {
      if (data.isNotEmpty) {
        final desc = data['weather'][0]['description'];
        if (weatherDiscription.containsKey(desc)) {
          backgroundImage = weatherDiscription[desc]![1];
          animation = weatherDiscription[desc]![0];
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

                    weatherAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Text("");
                        }
                        return Column(
                          children: [
                            // weather data from API.
                            WeatherCard(
                              city: data['name'],
                              country: data['sys']['country'],
                              description: data['weather'][0]['description'],
                              temp: kelvinToCelsius(data["main"]["temp"]),
                              low: kelvinToCelsius(data['main']['temp_min']),
                              high: kelvinToCelsius(data['main']['temp_max']),
                              humidity: data['main']['humidity'],
                              pressure: data['main']['pressure'],
                              windspeed: data['wind']['speed'],
                              animation: animation,
                            ),
                            const SizedBox(height: 20),
                            WeatherDetail(
                              windSpeed: data['wind']['speed'],
                              humidity: data['main']['humidity'],
                              pressure: data['main']['pressure'],
                              sunrise: data['sys']['sunrise'],
                              sunset: data['sys']['sunset'],
                              visibility: data['visibility'],
                            ),
                            const SizedBox(height: 10),
                            Button(
                              text: 'Add to watchList',
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
