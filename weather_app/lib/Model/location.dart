class Location {
  double? latitude;
  double? longitude;
  String? locationMessage;

  Location({this.latitude, this.longitude, this.locationMessage});

  Location copyWith({
    double? latitude,
    double? longitude,
    String? locationMessage,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationMessage: locationMessage ?? this.locationMessage,
    );
  }
}
