import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyRoads.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoadsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const RoadsPage({Key? key, this.place, required this.id}) : super(key: key);

  @override
  _RoadsPageState createState() => _RoadsPageState();
}

class _RoadsPageState extends State<RoadsPage> {
  List<MyRoads> roadsList = [];
  final TextEditingController roadNameController = TextEditingController();

  bool isLoading = true;
  late String roadStatus;
  late String roadVehicleType;
  late AppLocalizations l;

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    roadStatus = l.stableOption;
    roadVehicleType = l.naOption;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    fetchRoads();
  }

  @override
  void dispose() {
    roadNameController.dispose();

    super.dispose();
  }

  String localTransNotNull(String selectedType, AppLocalizations l) {
    Map<String, String> translations = {
      "Regular Car": l.regularCarOption,
      "4x4": l.fourByFourOption,
      "Truck": l.truckOption,
      "Motorcycle": l.motorcycleOption,
      "Mule": l.muelOption,
      "by foot": l.byFootOption,
      "N/A": l.naOption,
      "Blocked": l.blockedOption,
      "Demolished": l.demolishedOption,
      "Unstable": l.unstableOption,
      "Stable": l.stableOption,
    };

    Map<String, String> arabicTranslations = {
      "سيارة عادية": l.regularCarOption,
      "4x4": l.fourByFourOption,
      "شاحنة": l.truckOption,
      "دراجة نارية": l.motorcycleOption,
      "بغل": l.muelOption,
      "سيرًا على الأقدام": l.byFootOption,
      "غير متوفر": l.naOption,
      "مسدود": l.blockedOption,
      "مهدم": l.demolishedOption,
      "غير مستقر": l.unstableOption,
      "مستقر": l.stableOption,
    };

    Map<String, String> frenchTranslations = {
      "Voiture ordinaire": l.regularCarOption,
      "4x4": l.fourByFourOption,
      "Camion": l.truckOption,
      "Motocyclette": l.motorcycleOption,
      "Mulet": l.muelOption,
      "À pied": l.byFootOption,
      "Non disponible": l.naOption,
      "Bloquée": l.blockedOption,
      "Démolie": l.demolishedOption,
      "Instable": l.unstableOption,
      "Stable": l.stableOption,
    };

    String translation = translations[selectedType] ??
        arabicTranslations[selectedType] ??
        frenchTranslations[selectedType] ??
        selectedType;

    return translation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.roadsPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : roadsList.isEmpty
              ? Center(
                  child: Text(l.noRoadsAddedText),
                )
              : ListView.builder(
                  itemCount: roadsList.length,
                  itemBuilder: (context, index) {
                    final road = roadsList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        roadsList.removeAt(index);
                        deleteRoad(road);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(road.roadName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${l.roadStatusLabelText}: ${localTransNotNull(road.roadStatus, l)}"),
                            Text(
                                "${l.vehicleTypeLabelText}: ${localTransNotNull(road.vehicleType, l)}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoadDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddRoadDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addRoadText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: roadNameController,
                decoration: InputDecoration(labelText: l.roadNameLabel),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: roadStatus,
                onChanged: (newValue) {
                  setState(() {
                    roadStatus = newValue ?? l.stableOption;
                  });
                },
                items: <String>[
                  l.blockedOption,
                  l.demolishedOption,
                  l.unstableOption,
                  l.stableOption
                ]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: roadVehicleType,
                onChanged: (newValue) {
                  setState(() {
                    roadVehicleType = newValue ?? l.naOption;
                  });
                },
                items: <String>[
                  l.regularCarOption,
                  l.fourByFourOption,
                  l.truckOption,
                  l.motorcycleOption,
                  l.muelOption,
                  l.byFootOption,
                  l.naOption
                ]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String roadName = roadNameController.text;
                final String selectedRoadStatus = roadStatus;
                final String vehicleType = roadVehicleType;

                if (roadName.isNotEmpty &&
                    roadStatus.isNotEmpty &&
                    vehicleType.isNotEmpty) {
                  final MyRoads newRoad = MyRoads(
                    roadName: roadName,
                    roadStatus: selectedRoadStatus,
                    vehicleType: vehicleType,
                  );

                  roadsList.add(newRoad);

                  await saveUpdatedInfrastructure();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.roadAddedSuccessText),
                    ),
                  );

                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: Text(l.add),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUpdatedInfrastructure() async {
    try {
      final firestore = FirebaseFirestore.instance;

      Infrastructure? infrastructure = widget.place!.infrastructure;
      infrastructure!.roadList = roadsList;

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure.roadList': infrastructure.toMap()['roadList'],
      });
    } catch (e) {
      debugPrint('Error updating infrastructure in Firestore: $e');
    }
  }

  Future<void> deleteRoad(MyRoads roadToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      roadsList.remove(roadToDelete);

      Infrastructure? infrastructure = widget.place!.infrastructure;
      infrastructure!.roadList = roadsList;

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure.roadList': infrastructure.toMap()['roadList'],
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error deleting road in Firestore: $e');
    }
  }

  Future<void> fetchRoads() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final infrastructureData = placeDocument.data()?['infrastructure'];

      if (infrastructureData != null &&
          infrastructureData is Map<String, dynamic>) {
        final infrastructure = Infrastructure.fromMap(infrastructureData);
        setState(() {
          roadsList = infrastructure.roadList ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
