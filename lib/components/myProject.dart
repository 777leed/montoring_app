import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class myProject extends StatelessWidget {
  final String title;
  final String img;
  const myProject({
    super.key,
    required this.img,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 95,
          height: 95,
          decoration: BoxDecoration(
              color: CustomColors.secondaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Image.asset(img, width: 95, height: 95),
            ],
          ),
        ),
        SizedBox(
            width: 95,
            child: Text(
              title,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
