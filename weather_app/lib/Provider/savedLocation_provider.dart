import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/Model/saveLocation.dart';

class SavedLocationProvider extends StateNotifier<List<SaveLocation>> {
  SavedLocationProvider()
    : super([
        SaveLocation(
          name: "Texas",
          temp: 75,
          latitude: 40.7128,
          longitude: -74.0060,
          description: "Sunny",
          high: 80,
          low: 70,
          country: "USA",
          backgroundImage: "assets/clearsky.jpeg",
        ),
        SaveLocation(
          name: "Tokyo",
          temp: 22,
          latitude: 35.6762,
          longitude: 139.6503,
          description: "Clear",
          high: 25,
          low: 18,
          country: "Japan",
          backgroundImage: "assets/brokenClouds.jpeg",
        ),
        SaveLocation(
          name: "Paris",
          temp: 18,
          latitude: 48.8566,
          longitude: 2.3522,
          description: "Sunny",
          high: 21,
          low: 15,
          country: "France",
          backgroundImage: "assets/Rain.jpeg",
        ),
        SaveLocation(
          name: "Sydney",
          temp: 26,
          latitude: -33.8688,
          longitude: 151.2093,
          description: "Clear Sky",
          high: 29,
          low: 22,
          country: "Australia",
          backgroundImage: "assets/mist.jpeg",
        ),
        SaveLocation(
          name: "Rio de Janeiro",
          temp: 30,
          latitude: -22.9068,
          longitude: -43.1729,
          description: "Sunny",
          high: 32,
          low: 27,
          country: "Brazil",
          backgroundImage: "assets/snow.jpeg",
        ),
        SaveLocation(
          name: "Cape Town",
          temp: 24,
          latitude: -33.9249,
          longitude: 18.4241,
          description: "Clear",
          high: 27,
          low: 20,
          country: "South Africa",
          backgroundImage: "assets/showerRain.jpeg",
        ),
        SaveLocation(
          name: "Dubai",
          temp: 35,
          latitude: 25.2769,
          longitude: 55.2962,
          description: "Clear",
          high: 38,
          low: 30,
          country: "UAE",
          backgroundImage: "assets/clearsky.jpeg",
        ),
        SaveLocation(
          name: "Barcelona",
          temp: 24,
          latitude: 41.3851,
          longitude: 2.1734,
          description: "Clear Sky",
          high: 27,
          low: 20,
          country: "Spain",
          backgroundImage: "assets/clearsky.jpeg",
        ),
      ]);

  void addLocation(SaveLocation location) {
    // not repeating the location name in the list
    state = state.where((x) => x.name != location.name).toList();
    state = [...state, location];
    // print("saved location added" + state.length.toString());
    // for (var i = 0; i < state.length; i++) {
    //   print(state[i].name);
    // }
  }

  void removeLocation(SaveLocation location) {
    state = state.where((x) => x != location).toList();
  }
}

final savedLocationProvider =
    StateNotifierProvider<SavedLocationProvider, List<SaveLocation>>(
      (ref) => SavedLocationProvider(),
    );
