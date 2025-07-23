import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const Footer({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                print("get weather info button pressed");
                GoRouter.of(
                  context,
                ).go("/weatherInfo?latitude=$latitude&longitude=$longitude");
              },
              child: const Text("Get Weather Info"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go("/about"),
              child: Text("About"),
            ),
          ],
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
