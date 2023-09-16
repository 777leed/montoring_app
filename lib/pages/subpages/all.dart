import 'package:flutter/material.dart';
import 'package:montoring_app/components/MyWorkshops.dart';
import 'package:montoring_app/components/myCard.dart';
import 'package:montoring_app/components/myProject.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:montoring_app/pages/wherePage.dart';
import 'package:montoring_app/styles.dart';

class allCategories extends StatelessWidget {
  const allCategories({super.key});

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
                  builder: (context) => wherePage(),
                ),
              );
            },
            img: 'Assets/images/earthquake.png',
            color: CustomColors.secondaryColor,
            title: "Moroco Earthquake",
            desc:
                "Disaster Recovery for towns and villages impacted by the earthquake"),
        SizedBox(
          height: 20,
        ),
        myTitle(
            title: "Projects",
            icon: Icon(
              Icons.flag_rounded,
            )),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          myProject(
              img: 'Assets/images/tassdert.png',
              title: "Tassdert Solar Panels"),
          myProject(
              img: 'Assets/images/zwinup1.png', title: "Zwin Up Acitivity I"),
          myProject(
              img: 'Assets/images/zwinup2.png', title: "Zwin Up Activity II"),
        ]),
        SizedBox(
          height: 20,
        ),
        myTitle(title: "Workshops", icon: Icon(Icons.track_changes_rounded)),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          MyWorkshops(
              img: 'Assets/images/earth.png', title: "Sustainability Wokrshop"),
          MyWorkshops(
              img: 'Assets/images/teamwork.png', title: "Group Management"),
          MyWorkshops(
              img: 'Assets/images/business.png', title: "Business Model"),
        ]),
      ],
    );
  }
}
