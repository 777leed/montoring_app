import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/styles.dart';

class ExplorePage extends StatelessWidget {
  final Place? place;
  final String? id;
  ExplorePage({super.key, required this.place, required this.id});
  List _images = [
    'https://images.unsplash.com/photo-1695153374208-1b8382bd6388?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
    'https://images.unsplash.com/photo-1695071336116-f61c2042630c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
    'https://images.unsplash.com/photo-1695017718128-a1dd19984b44?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'
  ];

  Widget buildPopulationRow(String type, String stat) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\u2022 $type',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.secondaryTextColor),
          ),
          Text(
            stat,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CustomColors.mainTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Myown Place",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "432 People",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Live Pictures",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.view_array)
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 140,
                  child: _images.isEmpty
                      ? Center(
                          child: Text('No pictures'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _showImageDialog(context, _images[index]);
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.only(
                                    right: 8.0, top: 8.0, bottom: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.network(
                                  _images[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Live Population",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.people_outline_sharp)
                  ],
                ),
                SizedBox(height: 10),
                buildPopulationRow("Total Men", "1210"),
                buildPopulationRow("Total Women", "110"),
                buildPopulationRow("Total Boys", "160"),
                buildPopulationRow("Total Girls", "10"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Infrastructure",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.house)
                  ],
                ),
                buildPopulationRow("Road Name", "Tizi N Tast"),
                buildPopulationRow("Road Status", "Open"),
                buildPopulationRow("Vehicle Type", "4x4"),
                buildPopulationRow("Electricity", "Available"),
                buildPopulationRow("Water", "Available"),
                buildPopulationRow("Damaged Infrastructures", "873"),
                buildPopulationRow("Intact Infrastructures", "1872"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Supplies",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.shopping_bag)
                  ],
                ),
                buildPopulationRow("Tents", "17"),
                buildPopulationRow("Pallets", "28"),
                buildPopulationRow("Blankets", "43"),
                buildPopulationRow("Cushions", "23"),
                buildPopulationRow("Food", "Low"),
                buildPopulationRow("Hygiene Products", "Low"),
                buildPopulationRow("Medicine/First Aid", "Low"),
                buildPopulationRow("Construction Material", "Low"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
