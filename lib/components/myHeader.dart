import 'package:flutter/material.dart';

class myHeader extends StatelessWidget {
  final String title;
  final Icon icon;

  myHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        icon
      ],
    );
  }
}
