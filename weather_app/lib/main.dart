import "dart:io";

import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import "Screens/getLocation.dart";
import "package:go_router/go_router.dart";
import "Screens/weather.dart";
import "Screens/about.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // await dotenv.load(fileName: ".env");
  final goRouter = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const MyLocation()),
      GoRoute(
        path: "/weatherInfo",
        builder: (context, state) {
          return Weather();
        },
      ),
      GoRoute(path: "/about", builder: (context, state) => const About()),
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
