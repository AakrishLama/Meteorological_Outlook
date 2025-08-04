import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Provider/Location_provider.dart';
import 'package:weather_app/widgets/button.dart';

class Footer extends ConsumerWidget {
  final double? inputLat;
  final double? inputLong;

  const Footer(this.inputLat, this.inputLong, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    void goToWeatherInfo(BuildContext context) {
      final latitude = locationState.latitude;
      final longitude = locationState.longitude;

      if (latitude != null && longitude != null) {
        GoRouter.of(
          context,
        ).go("/weatherInfo?latitude=$latitude&longitude=$longitude");
        print("get weather info button pressed $latitude $longitude");
      }
    }

    return ClipRSuperellipse(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.white54, thickness: 0.6),
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 0,
                alignment: WrapAlignment.center,
                children: [
                  Button(
                    text: "",
                    onPressed: () => GoRouter.of(context).go("/"),
                    icon: Icons.home,
                  ),
                  if (locationState.latitude != null &&
                      locationState.longitude != null)
                    Button(
                      text: "Forecast",
                      onPressed: () => goToWeatherInfo(context),
                      icon: Icons.cloud
                    )
                  else
                    Opacity(
                      opacity: 0.4,
                      child: Button(text: "Forecast", onPressed: () {}),
                    ),
                  Button(
                    text: 'About',
                    onPressed: () => GoRouter.of(context).go("/about"),

                  ),
                  Button(
                    onPressed: () => GoRouter.of(context).go("/watchlist"),
                    text: '',
                    icon: Icons.bookmark,
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
