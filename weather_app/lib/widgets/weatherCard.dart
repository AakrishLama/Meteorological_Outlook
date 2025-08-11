import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatefulWidget {
  final String city, country, description, animation;
  final int temp, low, high, humidity, pressure;
  final double windspeed;

  const WeatherCard({
    super.key,
    required this.city,
    required this.country,
    required this.description,
    required this.temp,
    required this.low,
    required this.high,
    required this.humidity,
    required this.pressure,
    required this.windspeed,
    required this.animation,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for sliding & bouncing
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), 
    );

    // Slide from right (Offset(1, 0)) to left (Offset(0, 0)) with bounce
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(7, 0), // Start off-screen right
          end: Offset.zero, 
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.elasticOut, // Bounce effect
          ),
        );

    // Start animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation, 
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 220,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white30, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.city,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.country,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Lottie.asset(widget.animation, height: 100, width: 200),
                        Text(
                          "${widget.temp}°C",
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          widget.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        // current date and time.
                        Text(
                          "${DateFormat.yMMMMEEEEd().format(DateTime.now())}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white38,
                      thickness: 0.6,
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High: ${widget.high}°C",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Low: ${widget.low}°C",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Humidity: ${widget.humidity}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Pressure: ${widget.pressure}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
