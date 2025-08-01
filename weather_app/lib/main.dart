import "dart:io";

import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:weather_app/Screens/watchlist.dart";
import "Screens/home.dart";
import "package:go_router/go_router.dart";
import "Screens/forecast.dart";
import "Screens/about.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // await dotenv.load(fileName: ".env");
  final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          final lat = double.tryParse(
            state.uri.queryParameters['latitude'] ?? '',
          );
          final long = double.tryParse(
            state.uri.queryParameters['longitude'] ?? '',
          );
          return MyLocation(lat: lat, long: long);
        },
      ),
      GoRoute(
        path: "/weatherInfo",
        builder: (context, state) {
          final inputLatStr = state.uri.queryParameters['latitude'];
          final inputLongStr = state.uri.queryParameters['longitude'];

          final inputLat = inputLatStr != null
              ? double.tryParse(inputLatStr)
              : null;
          final inputLong = inputLongStr != null
              ? double.tryParse(inputLongStr)
              : null;
          return Weather(inputLat, inputLong);
        },
      ),
      GoRoute(path: "/about", builder: (context, state) => const About()),
      GoRoute(
        path: "/watchlist",
        builder: (context, state) => const Watchlist(),
      ),
    ],
  );

  runApp(ProviderScope(child: MyWidget(goRouter: goRouter)));
}

class MyWidget extends StatelessWidget {
  final GoRouter goRouter;

  const MyWidget({super.key, required this.goRouter}); // Add constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: goRouter,
    );
  }
}
