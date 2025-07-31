import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/Model/saveLocation.dart';

class SavedLocationProvider extends StateNotifier<List<SaveLocation>> {
  SavedLocationProvider() : super([]);

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
