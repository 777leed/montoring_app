import 'package:cloud_firestore/cloud_firestore.dart';

class MyNeeds {
  final String name;
  final int quantity;
  final String needType;
  final DateTime date;
  final String comment;

  MyNeeds(
      {required this.name,
      required this.quantity,
      required this.needType,
      required this.date,
      required this.comment});

  factory MyNeeds.fromMap(Map<String, dynamic> data) {
    return MyNeeds(
      name: data['needName'],
      quantity: data['quantity'],
      needType: data['needType'],
      comment: data['comment'],
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'needName': name,
      'quantity': quantity,
      'needType': needType,
      'date': date,
      'comment': comment
    };
  }

  @override
  String toString() {
    return 'need Name: $name, Quantity: $quantity, need Type: $needType, Date: $date, Comment: $comment';
  }
}
