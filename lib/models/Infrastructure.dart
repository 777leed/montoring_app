class Infrastructure {
  final String type;
  final String condition;

  Infrastructure({
    required this.type,
    required this.condition,
  });

  factory Infrastructure.fromMap(Map<String, dynamic> data) {
    return Infrastructure(
      type: data['type'],
      condition: data['condition'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'condition': condition,
    };
  }
}
