import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyBuilding.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const BuildingPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _BuildingPageState createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  List<MyBuilding> buildings = [];
  late String selectedCondition;
  late String selectedType;
  final TextEditingController buildingTypeController = TextEditingController();
  late AppLocalizations l;
  late List<String> buildingTypes;
  late List<String> buildingConditions;
  bool isLoading = true;

  late String otherText;
  late String kinderText;
  late String unkText;

  @override
  void initState() {
    super.initState();
    fetchBuildings();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    selectedCondition = l.unknownText;
    selectedType = l.kindergartenText;
    unkText = l.unknownText;
    kinderText = l.kindergartenText;
    otherText = l.otherType;
    buildingTypes = [
      l.kindergartenText,
      l.schoolText,
      l.storeText,
      l.coOpText,
      l.associationText,
      l.clinicText,
      l.otherType
    ];
    buildingConditions = [
      l.unknownText,
      l.demolishedOption,
      l.unstableOption,
    ];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String localTransNotNull(String selectedStatus, AppLocalizations l) {
    Map<String, String> translations = {
      "Kindergarten": l.kindergartenText,
      "روض أطفال": l.kindergartenText,
      "Jardin d'enfants": l.kindergartenText,
      "School": l.schoolText,
      "مدرسة": l.schoolText,
      "École": l.schoolText,
      "Store": l.storeText,
      "متجر": l.storeText,
      "Magasin": l.storeText,
      "Co-op": l.coOpText,
      "تعاونية": l.coOpText,
      "Coopérative": l.coOpText,
      "Association": l.associationText,
      "جمعية": l.associationText,
      "Clinic": l.clinicText,
      "عيادة": l.clinicText,
      "Clinique": l.clinicText,
      "Stable": l.stableOption,
      "مستقر": l.stableOption,
      "Unstable": l.unstableOption,
      "غير مستقر": l.unstableOption,
      "Instable": l.unstableOption,
      "Demolished": l.demolishedOption,
      "مهدم": l.demolishedOption,
      "Démolie": l.demolishedOption,
      "Blocked": l.blockedOption,
      "مسدود": l.blockedOption,
      "Bloquée": l.blockedOption,
      "Unknown": l.unknownText,
      "غير معروف": l.unknownText,
      "Inconnu": l.unknownText
    };

    return translations[selectedStatus] ?? selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.titleBuildings),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildings.isEmpty
              ? Center(
                  child: Text(l.noBuildings),
                )
              : ListView.builder(
                  itemCount: buildings.length,
                  itemBuilder: (context, index) {
                    final building = buildings[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        buildings.removeAt(index);
                        deleteBuilding(building);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title:
                            Text(localTransNotNull(building.buildingType, l)),
                        subtitle:
                            Text(localTransNotNull(building.condition, l)),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddBuildingDialog(context);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddBuildingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(l.addBuilding),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l.buildingType,
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButtonFormField(
                  value: selectedType.isNotEmpty ? selectedType : kinderText,
                  items: buildingTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value as String;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  l.condition,
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButtonFormField(
                  value: selectedCondition.isNotEmpty
                      ? selectedCondition
                      : unkText,
                  items: buildingConditions.map((condition) {
                    return DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value as String;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                if (selectedType == otherText) ...[
                  TextField(
                    controller: buildingTypeController,
                    decoration: InputDecoration(labelText: l.typeLabelText),
                  ),
                ],
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  String newtype;
                  if (selectedType == otherText) {
                    newtype = buildingTypeController.text;
                  } else {
                    newtype = selectedType;
                  }

                  if (newtype.isNotEmpty && selectedCondition.isNotEmpty) {
                    final MyBuilding newBuilding = MyBuilding(
                      buildingType: newtype,
                      condition: selectedCondition,
                    );

                    buildings.add(newBuilding);
                    await saveUpdatedPlace();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.buildingAdded),
                      ),
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: Text(l.add),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> saveUpdatedPlace() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final List<Map<String, dynamic>> updatedBuildingsData =
          buildings.map((building) => building.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure.buildings': updatedBuildingsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteBuilding(MyBuilding buildingToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      buildings.remove(buildingToDelete);

      final List<Map<String, dynamic>> updatedBuildingsData =
          buildings.map((building) => building.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure.buildings': updatedBuildingsData,
      });
    } catch (e) {
      debugPrint('Error deleting building from Firestore: $e');
    }
  }

  Future<void> fetchBuildings() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final infrastructureData = placeDocument.data()?['infrastructure'];

        if (infrastructureData != null &&
            infrastructureData is Map<String, dynamic>) {
          final buildingsData = infrastructureData['buildings'];
          if (buildingsData != null) {
            List<MyBuilding> loadedBuildings = (buildingsData as List)
                .map((building) => MyBuilding.fromMap(building))
                .toList();
            setState(() {
              buildings = loadedBuildings;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error loading buildings data from Firestore: $e $stacktrace');
    }
  }
}
