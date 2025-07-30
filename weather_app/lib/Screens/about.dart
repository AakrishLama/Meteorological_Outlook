import 'package:flutter/material.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';
import "package:go_router/go_router.dart";

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(heading: 'About',),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("This is the about page"),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).go("/"),
                      child: const Text("Go back"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer at the bottom as other screens.
           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Footer(),
          ),
        ],
      ),
    );
  }
}