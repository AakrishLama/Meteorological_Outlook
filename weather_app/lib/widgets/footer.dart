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

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.black, thickness: 1)),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            Button(
              text: 'Home',
              onPressed: () => GoRouter.of(context).go("/"),
              icon: Icons.home,
            ),
            const SizedBox(width: 10),
            if (locationState.latitude != null &&
                locationState.longitude != null)
              Button(
                text: "Forecast",
                onPressed: () => goToWeatherInfo(context),
              )
            else
              Opacity(
                opacity: 0.4,
                child: Button(
                  text: "Forecast",
                  onPressed: () {}, // do nothing
                ),
              ),
            const SizedBox(width: 10),
            Button(
              text: 'About',
              onPressed: () => GoRouter.of(context).go("/about"),
              icon: Icons.info,
            ),
            const SizedBox(width: 10),
            Button(
              onPressed: () => GoRouter.of(context).go("/watchlist"),
              text: 'Watchlist',
            ),
          ],
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
