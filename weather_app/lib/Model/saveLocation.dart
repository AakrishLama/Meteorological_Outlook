class SaveLocation {
  String name;
  int temp;
  final double latitude;
  final double longitude;
  String description;
  int high;
  int low;
  String country;

  SaveLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    required this.high,
    required this.low,
    required this.temp,
    required this.country,
  });
}
