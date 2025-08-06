import 'package:flutter/material.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: Appbar(heading: 'About'),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/flutter_01.png',
                          height: 900,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The home screen of this app displays the current weather and also allows the user to"
                      " search for weather of their desired city."  
                      "user can also add the city to their watchlist by clicking on the Add icon.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/flutter_02.png',
                          height: 900,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      "The Forecast screen displays the 5-day forecast for the user's location"
                      "with an interval of 3 hours.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/flutter_03.png',
                          height: 900,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                     "The Watchlist screen allows the user to save their favorite locations"
                     " and view them when clicked on the watchlist icon.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Footer always at the bottom
            const Footer(null, null),
          ],
        ),
      ),
    );
  }
}
