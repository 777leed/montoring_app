class MyCoordinates {
  double latitude;
  double longitude;

  MyCoordinates({required this.latitude, required this.longitude});

  factory MyCoordinates.fromMap(Map<String, dynamic> map) {
    return MyCoordinates(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return 'Latitude: $latitude, Longitude: $longitude';
  }
}
