class Infrastructure {
  final String type;
  final String condition;

  Infrastructure({
    required this.type,
    required this.condition,
  });

  // Deserialize data from Firestore to an Infrastructure object
  factory Infrastructure.fromMap(Map<String, dynamic> data) {
    return Infrastructure(
      type: data['type'],
      condition: data['condition'],
    );
  }

  // Serialize an Infrastructure object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'condition': condition,
    };
  }
}
