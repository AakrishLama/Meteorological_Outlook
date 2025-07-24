import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Provider/Location_provider.dart';

class Footer extends ConsumerWidget {
  // final double? latitude;
  // final double? longitude;

  // const Footer({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

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
            ElevatedButton(
              onPressed: locationState.latitude != null && 
                      locationState.longitude != null
                  ?() {
                print("get weather info button pressed");
                GoRouter.of(context).go("/weatherInfo?");
              }: null,
              child: const Text("Get Weather Info"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed:
                   () => GoRouter.of(context).go("/about")
                  ,
              child: Text("About"),
            ),
          ],
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
