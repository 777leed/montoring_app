import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class MyWorkshops extends StatelessWidget {
  final String title;
  final String img;
  const MyWorkshops({
    super.key,
    required this.img,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          width: 95,
          height: 95,
          decoration: BoxDecoration(
              color: CustomColors.secondaryColor, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                img,
                width: 80,
                height: 80,
                fit: BoxFit.scaleDown,
              ),
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
