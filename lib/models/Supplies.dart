class Supplies {
  final String supplyName;
  final int quantity;
  final String supplyType;

  Supplies({
    required this.supplyName,
    required this.quantity,
    required this.supplyType,
  });

  // Deserialize data from Firestore to a Supplies object
  factory Supplies.fromMap(Map<String, dynamic> data) {
    return Supplies(
      supplyName: data['supplyName'],
      quantity: data['quantity'],
      supplyType: data['supplyType'],
    );
  }

  // Serialize a Supplies object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'supplyName': supplyName,
      'quantity': quantity,
      'supplyType': supplyType,
    };
  }
}
