import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class addNew extends StatelessWidget {
  const addNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondaryLighterColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unavailable",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Image.asset(
                  'Assets/images/unavailable.png',
                  width: 100,
                  height: 100,
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
