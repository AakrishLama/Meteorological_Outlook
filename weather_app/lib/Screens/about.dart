import 'package:flutter/material.dart';
import 'package:weather_app/widgets/footer.dart';
import "package:go_router/go_router.dart";

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Info", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is the about page"),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go("/"),
              child: const Text("Go back"),
            ),
          ],
        ),
      ),
    );
  }
}
