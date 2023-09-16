import 'package:flutter/material.dart';
import 'package:montoring_app/pages/InventoryPage.dart';
import 'package:montoring_app/pages/disasterPage.dart';

import 'package:montoring_app/styles.dart';

class wherePage extends StatefulWidget {
  const wherePage({super.key});

  @override
  State<wherePage> createState() => _wherePageState();
}

class _wherePageState extends State<wherePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // This will navigate back to the previous screen (homepage).
          },
        ),
        title: Text('Inventory Page'),
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
                    builder: (context) => DisasterPage(),
                  ),
                );
              },
              child: Container(
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
                        "Our Map",
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.map,
                        size: 60,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
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
              child: Container(
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
                        "Inventory",
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.inventory,
                        size: 60,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
