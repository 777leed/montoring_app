// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:montoring_app/components/EditCard.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/styles.dart';

class PlaceDetails extends StatefulWidget {
  final String name;
  const PlaceDetails({super.key, required this.name});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            GoBack(
              title: widget.name,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EditCard(
                  title: "Supplies\nGiven",
                  img: "Assets/images/supplies.png",
                ),
                EditCard(
                  title: "Population\nStatus",
                  img: "Assets/images/groups.png",
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EditCard(
                  title: "Infrastruc\nture Status",
                  img: "Assets/images/construction.png",
                ),
                EditCard(
                  title: "Current\nStatus",
                  img: "Assets/images/time.png",
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
