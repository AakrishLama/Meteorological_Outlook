import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDetail extends StatefulWidget {
  final double windSpeed;
  final int humidity, pressure, sunrise, sunset, visibility;

  const WeatherDetail({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
  });

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );


    _slideAnimation = Tween<Offset>(
      begin: const Offset(7, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Format UNIX time to readable time
  String _formatTime(int timestamp) {
    return DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  // Convert visibility to km if needed
  String _formatVisibility(int meters) {
    return meters >= 1000
        ? "${(meters / 1000).toStringAsFixed(1)} km"
        : "$meters m";
  }

  Widget smallBox(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white30, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white30, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weather Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        smallBox(Icons.visibility, "Visibility",
                            _formatVisibility(widget.visibility)),
                        smallBox(Icons.water_drop, "Humid",
                            "${widget.humidity}%"),
                        smallBox(Icons.speed, "Pressure",
                            "${widget.pressure} hPa"),
                      ],
                    ),
                    Row(
                      children: [
                        smallBox(Icons.wb_sunny, "Sunrise",
                            _formatTime(widget.sunrise)),
                        smallBox(Icons.nightlight_round, "Sunset",
                            _formatTime(widget.sunset)),
                        smallBox(Icons.air, "Wind Speed",
                            "${(widget.windSpeed * 3.6).toStringAsFixed(1)} km/h"),
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
