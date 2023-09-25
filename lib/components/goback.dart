import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  final String title;
  final Function onTap;
  const GoBack({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              onTap();
            },
            child: Icon(Icons.arrow_back_rounded)),
        SizedBox(
          width: 20,
        ),
        Container(
          width: 200,
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
