class SaveLocation {
  String name;
  final double latitude;
  final double longitude;
  String description;
  double high;
  double low;

  SaveLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    required this.high,
    required this.low,
  });
}
