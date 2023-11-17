import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class addNew extends StatelessWidget {
  const addNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.secondaryLighterColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/images/unavailable.png',
                width: 100,
                height: 100,
              )
            ],
          ),
        ),
      )),
    );
  }
}
