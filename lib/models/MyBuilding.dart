class MyBuilding {
  String buildingType;
  String condition;

  MyBuilding({
    required this.buildingType,
    required this.condition,
  });

  factory MyBuilding.fromMap(Map<String, dynamic> data) {
    return MyBuilding(
      buildingType: data['buildingType'],
      condition: data['condition'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingType': buildingType,
      'condition': condition,
    };
  }
}
