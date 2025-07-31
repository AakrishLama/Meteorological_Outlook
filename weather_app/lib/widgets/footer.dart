import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Provider/Location_provider.dart';

class Footer extends ConsumerWidget {
  final double? inputLat;
  final double? inputLong;

  const Footer(this.inputLat, this.inputLong, {super.key});

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
              onPressed:
                   () => GoRouter.of(context).go("/")
                  ,
              child: Text("Home"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: locationState.latitude != null && 
                      locationState.longitude != null
                  ?() {
                GoRouter.of(context).go("/weatherInfo?latitude=${inputLat.toString()}&longitude=${inputLong.toString()}");
                print("get weather info button pressed ${inputLat.toString()} ${inputLong.toString()}");
              }: null,
              child: const Text("Forecast"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed:
                   () => GoRouter.of(context).go("/about")
                  ,
              child: Text("About"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: ()=> GoRouter.of(context).go("/watchlist")
                  ,
              child: Text("Watchlist"),
            ),
          ],
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
