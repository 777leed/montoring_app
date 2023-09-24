import 'package:flutter/material.dart';

class SupplyCard extends StatelessWidget {
  final String supplyType;

  SupplyCard({required this.supplyType});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              supplyType,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount for $supplyType',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
