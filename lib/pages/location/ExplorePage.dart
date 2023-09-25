import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/styles.dart';

class ExplorePage extends StatefulWidget {
  final Place? place;
  final String? id;
  ExplorePage({super.key, required this.place, required this.id});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List _images = [];

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

  Future<void> loadImagesFromFirestore() async {
    try {
      final placeRef =
          FirebaseFirestore.instance.collection('places').doc(widget.id);
      final placeDoc = await placeRef.get();
      if (placeDoc.exists) {
        final data = placeDoc.data() as Map<String, dynamic>;
        if (data.containsKey('images')) {
          final imageUrls = data['images'] as List<dynamic>;
          setState(() {
            _images = imageUrls.cast<String>().toList();
          });
        }
      }
    } catch (e) {
      print('Error loading images from Firestore: $e');
    }
  }

  Widget _buildNeedTile(String need) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '\u2022 ',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.secondaryTextColor),
        ),
        Flexible(
          child: Text(
            need,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CustomColors.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader(String title, Icon icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10,
        ),
        icon
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    loadImagesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    List<Contacts>? contactsList = widget.place!.contacts;
    int? animals = widget.place!.population!.totalLivestockAnimals;
    int? men_total = widget.place!.population!.totalMenBefore -
        widget.place!.population!.totalMenDeaths;
    int? women_total = widget.place!.population!.totalWomenBefore -
        widget.place!.population!.totalWomenDeaths;
    int? boys_total = widget.place!.population!.totalBoysBefore -
        widget.place!.population!.totalBoysDeaths;
    int? girls_total = widget.place!.population!.totalGirlsBefore -
        widget.place!.population!.totalGirlsDeaths;
    String roadName = widget.place!.infrastructure!.roadName;
    String roadStatus = widget.place!.infrastructure!.roadStatus;
    String vehicleType = widget.place!.infrastructure!.roadVehicleType;
    String elecStatus = widget.place!.infrastructure!.electricityStatus;
    String waterStatus = widget.place!.infrastructure!.waterStatus;
    int homesdamaged = widget.place!.infrastructure!.totalHomesDemolished +
        widget.place!.infrastructure!.totalHomesUnstable;
    int schoolsdamaged = widget.place!.infrastructure!.totalSchoolsDemolished +
        widget.place!.infrastructure!.totalSchoolsUnstable;
    int storesdamaged = widget.place!.infrastructure!.totalStoresDemolished +
        widget.place!.infrastructure!.totalStoresUnstable;
    int mosquesdamaged = widget.place!.infrastructure!.totalMosquesDemolished +
        widget.place!.infrastructure!.totalMosquesUnstable;
    int totalDamage =
        homesdamaged + schoolsdamaged + mosquesdamaged + storesdamaged;
    int totalNotDamaged = widget.place!.infrastructure!.totalHomesIntact +
        widget.place!.infrastructure!.totalSchoolsIntact +
        widget.place!.infrastructure!.totalMosquesIntact +
        widget.place!.infrastructure!.totalStoresIntact;
    String tents = widget.place!.currentSupplies!["Tents"];
    String cushions = widget.place!.currentSupplies!["Cushions"];
    String pallets = widget.place!.currentSupplies!["Pallets"];
    String blankets = widget.place!.currentSupplies!["Blankets"];
    String food = widget.place!.currentSupplies!["Food"];
    String med = widget.place!.currentSupplies!["Medicine/First Aid"];
    String hygiene = widget.place!.currentSupplies!["Hygiene Products"];
    String construction = widget
        .place!.currentSupplies!["Construction Materials for Building Rehab"];

    String tentsn = widget.place!.neededSupplies!["Tents"];
    String cushionsn = widget.place!.neededSupplies!["Cushions"];
    String palletsn = widget.place!.neededSupplies!["Pallets"];
    String blanketsn = widget.place!.neededSupplies!["Blankets"];
    String foodn = widget.place!.neededSupplies!["Food"];
    String medn = widget.place!.neededSupplies!["Medicine/First Aid"];
    String hygienen = widget.place!.neededSupplies!["Hygiene Products"];
    String constructionn = widget
        .place!.neededSupplies!["Construction Materials for Building Rehab"];
    List<String>? needsList = widget.place!.needs;

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
                  StringUtils.capitalize(widget.place!.name),
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
                buildHeader("Live Pictures", Icon(Icons.view_array)),
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
                buildHeader(
                    "Live Population", Icon(Icons.people_outline_sharp)),
                SizedBox(height: 10),
                buildPopulationRow("Total Men", men_total.toString()),
                buildPopulationRow("Total Women", women_total.toString()),
                buildPopulationRow("Total Boys", boys_total.toString()),
                buildPopulationRow("Total Girls", girls_total.toString()),
                buildPopulationRow(
                    "Total Livestock Animals", animals.toString()),
                SizedBox(height: 20),
                buildHeader("Infrastructure", Icon(Icons.house)),
                buildPopulationRow("Road Name", roadName),
                buildPopulationRow("Road Status", roadStatus),
                buildPopulationRow("Vehicle Type", vehicleType),
                buildPopulationRow("Electricity", elecStatus),
                buildPopulationRow("Water", waterStatus),
                buildPopulationRow(
                    "Damaged Infrastructures", totalDamage.toString()),
                buildPopulationRow(
                    "Intact Infrastructures", totalNotDamaged.toString()),
                SizedBox(height: 20),
                buildHeader("Current Supplies", Icon(Icons.shopping_bag)),
                buildPopulationRow("Tents", tents),
                buildPopulationRow("Pallets", pallets),
                buildPopulationRow("Blankets", blankets),
                buildPopulationRow("Cushions", cushions),
                buildPopulationRow("Food", food),
                buildPopulationRow("Hygiene Products", hygiene),
                buildPopulationRow("Medicine/First Aid", med),
                buildPopulationRow("Construction Material", construction),
                SizedBox(height: 20),
                buildHeader("Needed Supplies", Icon(Icons.shopping_cart)),
                buildPopulationRow("Tents", tentsn),
                buildPopulationRow("Pallets", palletsn),
                buildPopulationRow("Blankets", blanketsn),
                buildPopulationRow("Cushions", cushionsn),
                buildPopulationRow("Food", foodn),
                buildPopulationRow("Hygiene Products", hygienen),
                buildPopulationRow("Medicine/First Aid", medn),
                buildPopulationRow("Construction Material", constructionn),
                SizedBox(height: 20),
                buildHeader("Needs", Icon(Icons.waving_hand_rounded)),
                SizedBox(height: 10),
                if (needsList!.isEmpty) Text('No needs available.'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      needsList.map((need) => _buildNeedTile(need)).toList(),
                ),
                SizedBox(height: 20),
                buildHeader("Contacts", Icon(Icons.contact_emergency)),
                SizedBox(
                  height: 10,
                ),
                contactsList == null || contactsList.isEmpty
                    ? Center(
                        child: Text('No contacts'),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: contactsList.length,
                          itemBuilder: (context, index) {
                            final contact = contactsList[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text('Name: ${contact.name}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Phone Number: ${contact.phoneNumber}'),
                                    Text('Email: ${contact.email}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
