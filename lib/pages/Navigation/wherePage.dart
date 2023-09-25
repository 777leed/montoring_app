import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Maps/AddPlacePage.dart';
import 'package:montoring_app/pages/Maps/ExploreMap.dart';
import 'package:montoring_app/pages/User/AuthPage.dart';
import 'package:montoring_app/pages/Maps/EditPlacePage.dart';
import 'package:montoring_app/pages/data/ExportPage.dart';
import 'package:montoring_app/pages/data/InventoryPage.dart';

import 'package:montoring_app/styles.dart';

class WherePage extends StatelessWidget {
  const WherePage({Key? key});

  Widget buildButton(Icon icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
            Navigator.of(context).pushReplacement(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton(
                    Icon(
                      Icons.map,
                      size: 30,
                      color: Colors.white,
                    ),
                    'Add Areas',
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddPlacePage(),
                        ),
                      );
                    },
                  ),
                  buildButton(
                    Icon(
                      Icons.edit_location,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Edit Areas",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditPlacePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton(
                    Icon(
                      Icons.explore,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Explore",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExploreMap(),
                        ),
                      );
                    },
                  ),
                  buildButton(
                    Icon(
                      Icons.inventory,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Inventory",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InventoryPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton(
                    Icon(
                      Icons.import_export,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Export",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExportPage(),
                        ),
                      );
                    },
                  ),
                  buildButton(
                    Icon(
                      Icons.dashboard,
                      size: 30,
                      color: Colors.white,
                    ),
                    "Home",
                    () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
