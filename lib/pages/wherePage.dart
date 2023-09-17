import 'package:flutter/material.dart';
import 'package:montoring_app/pages/AddPlacePage.dart';
import 'package:montoring_app/pages/AuthPage.dart';
import 'package:montoring_app/pages/EditPlacePage.dart';
import 'package:montoring_app/pages/ExportPage.dart';
import 'package:montoring_app/pages/InventoryPage.dart';
import 'package:montoring_app/pages/disasterPage.dart';

import 'package:montoring_app/styles.dart';

class wherePage extends StatefulWidget {
  const wherePage({super.key});

  @override
  State<wherePage> createState() => _wherePageState();
}

class _wherePageState extends State<wherePage> {
  Widget buildbutton(Icon icon, String title) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            icon
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AuthPage(),
              ),
            );
          },
        ),
        title: Text('Features'),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPlacePage(),
                  ),
                );
              },
              child: buildbutton(
                  Icon(
                    Icons.map,
                    size: 60,
                    color: Colors.white,
                  ),
                  'Add Areas'),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditPlacePage(),
                  ),
                );
              },
              child: buildbutton(
                  Icon(
                    Icons.edit_location,
                    size: 60,
                    color: Colors.white,
                  ),
                  "Edit Areas"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InventoryPage(),
                  ),
                );
              },
              child: buildbutton(
                  Icon(
                    Icons.inventory,
                    size: 60,
                    color: Colors.white,
                  ),
                  "Inventory"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExportPage(),
                  ),
                );
              },
              child: buildbutton(
                  Icon(
                    Icons.import_export,
                    size: 60,
                    color: Colors.white,
                  ),
                  "Export Data"),
            )
          ],
        ),
      )),
    );
  }
}
