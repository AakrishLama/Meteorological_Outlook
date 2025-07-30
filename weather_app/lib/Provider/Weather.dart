import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:riverpod/riverpod.dart";
import "package:weather_app/Provider/Location_provider.dart";

final weatherProvider = FutureProvider.family<Map<String, dynamic>, (double lat, double lon)>((ref, coords) async {
  final inputLat = coords.$1;
  final inputLon = coords.$2;
  try {
    if (inputLat == null || inputLon == null) {
      return {};
    }
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': inputLat.toString(),
      'lon': inputLon.toString(),
      'appid': dotenv.env['API_KEY'] ?? '',
    });
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('API request failed: ${response.statusCode}');
    }
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonData;
  } catch (e) {
    throw Exception('Failed to fetch weather: $e');
  }
});
