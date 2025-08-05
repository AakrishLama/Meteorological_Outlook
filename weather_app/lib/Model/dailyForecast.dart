// lib/Model/dailyForecast.dart

class DailyForecast {
  final String date;
  final String day;
  final double minTemp;
  final double maxTemp;
  final String description;
  final List<Map<String, dynamic>> forecasts;

  DailyForecast({
    required this.date,
    required this.day,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.forecasts,
  });
}
