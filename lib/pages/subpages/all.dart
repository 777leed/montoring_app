import 'package:flutter/material.dart';
import 'package:montoring_app/components/MyWorkshops.dart';
import 'package:montoring_app/components/myCard.dart';
import 'package:montoring_app/components/myProject.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class allCategories extends StatelessWidget {
  const allCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          myTitle(
              title: AppLocalizations.of(context)!.disasterReliefTitle,
              icon: Icon(Icons.warning_rounded)),
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
              title: AppLocalizations.of(context)!.moroccoEarthquakeTitle,
              desc: AppLocalizations.of(context)!.disasterRecoveryDescription),
          SizedBox(
            height: 20,
          ),
          myTitle(
              title: AppLocalizations.of(context)!.projectsTitle,
              icon: Icon(
                Icons.flag_rounded,
              )),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            myProject(
                img: 'Assets/images/tassdert.png',
                title: AppLocalizations.of(context)!.tassdertSolarPanelsTitle),
            myProject(
                img: 'Assets/images/zwinup1.png',
                title: AppLocalizations.of(context)!.zwinUpActivityITitle),
            myProject(
                img: 'Assets/images/zwinup2.png',
                title: AppLocalizations.of(context)!.zwinUpActivityIITitle),
          ]),
          SizedBox(
            height: 20,
          ),
          myTitle(
              title: AppLocalizations.of(context)!.workshopsTitle,
              icon: Icon(Icons.track_changes_rounded)),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            MyWorkshops(
                img: 'Assets/images/earth.png',
                title:
                    AppLocalizations.of(context)!.sustainabilityWorkshopTitle),
            MyWorkshops(
                img: 'Assets/images/teamwork.png',
                title: AppLocalizations.of(context)!.groupManagementTitle),
            MyWorkshops(
                img: 'Assets/images/business.png',
                title: AppLocalizations.of(context)!.businessModelTitle),
          ]),
        ],
      ),
    );
  }
}
