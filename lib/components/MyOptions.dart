import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class MyOptions extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function onTap;
  const MyOptions(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(10)),
            width: 60,
            height: 60,
            child: icon,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 18, color: const Color.fromARGB(255, 100, 99, 99)),
          )
        ],
      ),
    );
  }
}
