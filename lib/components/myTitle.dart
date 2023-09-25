import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class myTitle extends StatelessWidget {
  final String title;
  final Icon icon;
  const myTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: CustomColors.mainTextColor)),
            SizedBox(
              width: 10,
            ),
            icon
          ],
        )
      ],
    );
  }
}
