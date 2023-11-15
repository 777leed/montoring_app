import 'package:flutter/material.dart';
import 'package:montoring_app/components/myProject.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class onlyProjects extends StatefulWidget {
  const onlyProjects({super.key});

  @override
  State<onlyProjects> createState() => _onlyProjectsState();
}

class _onlyProjectsState extends State<onlyProjects> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
