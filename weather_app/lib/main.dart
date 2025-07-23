import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import "getLocation.dart";
import "package:go_router/go_router.dart";
import "weather.dart";

void main() {
  final goRouter = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const MyLocation()),
      GoRoute(path: "/weatherInfo", builder: (context, state) =>  Weather()),
    ],
  );
  runApp(MyWidget(goRouter: goRouter));
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
