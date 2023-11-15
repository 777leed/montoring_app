import 'package:flutter/material.dart';
import 'package:montoring_app/components/MyWorkshops.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class onlyWorkshops extends StatelessWidget {
  const onlyWorkshops({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              title: AppLocalizations.of(context)!.sustainabilityWorkshopTitle),
          MyWorkshops(
              img: 'Assets/images/teamwork.png',
              title: AppLocalizations.of(context)!.groupManagementTitle),
          MyWorkshops(
              img: 'Assets/images/business.png',
              title: AppLocalizations.of(context)!.businessModelTitle),
        ]),
      ],
    );
  }
}
