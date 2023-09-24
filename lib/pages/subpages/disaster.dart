import 'package:flutter/material.dart';
import 'package:montoring_app/components/myCard.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/styles.dart';

class onlyDisaster extends StatelessWidget {
  const onlyDisaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        myTitle(title: "Disaster Relief", icon: Icon(Icons.warning_rounded)),
        SizedBox(
          height: 10,
        ),
        myCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WherePage(),
                ),
              );
            },
            img: 'Assets/images/earthquake.png',
            color: CustomColors.secondaryColor,
            title: "Moroco Earthquake",
            desc:
                "Disaster Recovery for towns and villages impacted by the earthquake"),
      ],
    );
  }
}
