import 'package:flutter/material.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(heading: 'Watchlist'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text("This is the watchlist page")],
                ),
              ),
            ),
          ),
          // Footer at the bottom as other screens.
          Positioned(bottom: 0, left: 0, right: 0, child: Footer(null, null)),
        ],
      ),
    );
  }
}
