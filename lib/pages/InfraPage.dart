import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfrastructuresPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const InfrastructuresPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<InfrastructuresPage> createState() => _InfrastructuresPageState();
}

class _InfrastructuresPageState extends State<InfrastructuresPage> {
  List<Infrastructure> infrastructuresList = [];
  String? selectedType;
  String? selectedCondition;
  List<String> typeList = ['Home', 'School', 'Road', 'Mosque', 'Other'];
  List<String> conditionList = [
    'No Damage',
    'Minor Damage',
    'Moderate Damage',
    'Severe Damage',
    'Irreparable Damage',
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInfrastructures();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Infrastructures",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading circle
            )
          : infrastructuresList.isEmpty
              ? Center(
                  child: Text("No infrastructures added yet"),
                )
              : ListView.builder(
                  itemCount: infrastructuresList.length,
                  itemBuilder: (context, index) {
                    final infrastructure = infrastructuresList[index];
                    final itemKey = UniqueKey();

                    return Dismissible(
                      key: itemKey,
                      onDismissed: (direction) {
                        infrastructuresList.removeAt(index);
                        deleteInfrastructure(infrastructure);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(infrastructure.type),
                        subtitle:
                            Text("Condition: ${infrastructure.condition}"),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddInfrastructureDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddInfrastructureDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Infrastructure'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                items: typeList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Type'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCondition,
                onChanged: (newValue) {
                  setState(() {
                    selectedCondition = newValue;
                  });
                },
                items:
                    conditionList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Condition'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (selectedType != null && selectedCondition != null) {
                  final Infrastructure newInfrastructure = Infrastructure(
                    type: selectedType!,
                    condition: selectedCondition!,
                  );

                  // Show loading circle when adding a new item
                  setState(() {
                    isLoading = true;
                  });

                  infrastructuresList.add(newInfrastructure);
                  await saveUpdatedPlace();

                  // Show snackbar when item is added
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Infrastructure added'),
                    ),
                  );

                  // Hide loading circle after adding item
                  setState(() {
                    isLoading = false;
                  });

                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUpdatedPlace() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final List<Map<String, dynamic>> updatedInfrastructuresData =
          infrastructuresList
              .map((infrastructure) => infrastructure.toMap())
              .toList();

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure': updatedInfrastructuresData,
      });
    } catch (e) {
      print('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteInfrastructure(Infrastructure infrastructure) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Remove the infrastructure from the local list
      infrastructuresList.remove(infrastructure);

      // Serialize the updated infrastructures list
      final List<Map<String, dynamic>> updatedInfrastructuresData =
          infrastructuresList
              .map((infrastructure) => infrastructure.toMap())
              .toList();

      // Update the place in Firestore
      await firestore.collection('places').doc(widget.id).update({
        'infrastructure': updatedInfrastructuresData,
      });

      setState(() {});
    } catch (e) {
      print('Error deleting infrastructure in Firestore: $e');
    }
  }

  Future<void> fetchInfrastructures() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final infrastructuresData = placeDocument.data()?['infrastructure'];

      if (infrastructuresData != null && infrastructuresData is List<dynamic>) {
        final infrastructures = infrastructuresData
            .map((data) => Infrastructure.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          infrastructuresList = infrastructures;
          isLoading = false;
        });
      }
    }
  }
}
