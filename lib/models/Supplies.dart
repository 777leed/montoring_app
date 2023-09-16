import 'package:cloud_firestore/cloud_firestore.dart';

class Supplies {
  final String supplyName;
  final int quantity;
  final String supplyType;
  final DateTime date; // New field for the date

  Supplies({
    required this.supplyName,
    required this.quantity,
    required this.supplyType,
    required this.date, // Include the date in the constructor
  });

  // Deserialize data from Firestore to a Supplies object
  factory Supplies.fromMap(Map<String, dynamic> data) {
    return Supplies(
      supplyName: data['supplyName'],
      quantity: data['quantity'],
      supplyType: data['supplyType'],
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(), // Deserialize date from Firestore
    );
  }

  // Serialize a Supplies object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'supplyName': supplyName,
      'quantity': quantity,
      'supplyType': supplyType,
      'date': date, // Serialize date to Firestore
    };
  }
}
