import 'package:cloud_firestore/cloud_firestore.dart';

class Supplies {
  final String supplyName;
  final int quantity;
  final String supplyType;
  final DateTime date;

  Supplies({
    required this.supplyName,
    required this.quantity,
    required this.supplyType,
    required this.date,
  });

  factory Supplies.fromMap(Map<String, dynamic> data) {
    return Supplies(
      supplyName: data['supplyName'],
      quantity: data['quantity'],
      supplyType: data['supplyType'],
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplyName': supplyName,
      'quantity': quantity,
      'supplyType': supplyType,
      'date': date,
    };
  }
}
