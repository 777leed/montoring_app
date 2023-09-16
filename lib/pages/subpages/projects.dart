// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, camel_case_types

import 'package:flutter/material.dart';
import 'package:montoring_app/components/myProject.dart';
import 'package:montoring_app/components/myTitle.dart';

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
      ],
    );
  }
}
