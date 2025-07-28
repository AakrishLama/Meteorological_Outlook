import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:riverpod/riverpod.dart";
import "package:weather_app/Provider/Location_provider.dart";

final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    final locationState = ref.watch(locationProvider);
    final lat = locationState.latitude;
    final lon = locationState.longitude;
    print("lat: $lat, lon: $lon from weatherProvider");
    if (lat == null || lon == null) {
      throw Exception('Coordinates not available');
    }
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': dotenv.env['API_KEY'] ?? '',
    });
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('API request failed: ${response.statusCode}');
    }
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonData;
  } catch (e) {
    throw Exception('error: $e');
  }
});
