class IrrigationSystem {
  String name;
  String purpose;
  String timing;

  IrrigationSystem({
    required this.name,
    required this.purpose,
    required this.timing,
  });

  factory IrrigationSystem.fromMap(Map<String, dynamic> data) {
    return IrrigationSystem(
      name: data['name'],
      purpose: data['purpose'],
      timing: data['timing'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'purpose': purpose,
      'timing': timing,
    };
  }
}
