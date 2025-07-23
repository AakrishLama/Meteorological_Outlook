import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import "Screens/getLocation.dart";
import "package:go_router/go_router.dart";
import "Screens/weather.dart";
import "Screens/about.dart";

void main() {
  final goRouter = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const MyLocation()),
      GoRoute(path: "/weatherInfo", builder: (context, state){
          final lat = double.tryParse(state.uri.queryParameters['latitude']?? "");
          final lon = double.tryParse(state.uri.queryParameters['longitude']?? "");
          return Weather(latitude: lat, longitude: lon);
      },
      ),
      GoRoute(path: "/about", builder:(context, state)=> const About()),  
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
