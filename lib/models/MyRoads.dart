class MyRoads {
  final String roadName;
  final String roadStatus;
  final String vehicleType;

  MyRoads({
    required this.roadName,
    required this.roadStatus,
    required this.vehicleType,
  });

  factory MyRoads.fromMap(Map<String, dynamic> map) {
    return MyRoads(
      roadName: map['roadName'],
      roadStatus: map['roadStatus'],
      vehicleType: map['vehicleType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roadName': roadName,
      'roadStatus': roadStatus,
      'vehicleType': vehicleType,
    };
  }

  @override
  String toString() {
    return 'Road Name: $roadName, Road Status: $roadStatus, Vehicle Type: $vehicleType';
  }
}
