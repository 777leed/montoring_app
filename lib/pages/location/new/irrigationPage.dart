import 'package:flutter/material.dart';
import 'package:montoring_app/models/IrrigationSystem.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IrrigationSystemPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const IrrigationSystemPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _IrrigationSystemPageState createState() => _IrrigationSystemPageState();
}

class _IrrigationSystemPageState extends State<IrrigationSystemPage> {
  List<IrrigationSystem> irrigationSystems = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController timingController = TextEditingController();
  bool isLoading = true;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchIrrigationSystems();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    purposeController.dispose();
    timingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.irrigationSystemsPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : irrigationSystems.isEmpty
              ? Center(
                  child: Text(l.noIrrigationSystemsAddedText),
                )
              : ListView.builder(
                  itemCount: irrigationSystems.length,
                  itemBuilder: (context, index) {
                    final irrigationSystem = irrigationSystems[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        irrigationSystems.removeAt(index);
                        deleteIrrigationSystem(irrigationSystem);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(irrigationSystem.name),
                        subtitle: Text(irrigationSystem.purpose),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddIrrigationSystemDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddIrrigationSystemDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addIrrigationSystemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l.systemNameLabelText),
              ),
              TextField(
                controller: purposeController,
                decoration: InputDecoration(labelText: l.purposeLabelText),
              ),
              TextField(
                controller: timingController,
                decoration: InputDecoration(labelText: l.timingLabelText),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final String purpose = purposeController.text;
                final String timing = timingController.text;

                if (name.isNotEmpty &&
                    purpose.isNotEmpty &&
                    timing.isNotEmpty) {
                  final IrrigationSystem newIrrigationSystem = IrrigationSystem(
                    name: name,
                    purpose: purpose,
                    timing: timing,
                  );

                  irrigationSystems.add(newIrrigationSystem);
                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.irrigationSystemAddedSuccessText),
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

  Future<void> saveUpdatedPlace() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final List<Map<String, dynamic>> updatedIrrigationSystemsData =
          irrigationSystems
              .map((irrigationSystem) => irrigationSystem.toMap())
              .toList();

      await firestore.collection('places').doc(widget.id).update({
        'irrigationSystems': updatedIrrigationSystemsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteIrrigationSystem(IrrigationSystem systemToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      irrigationSystems.remove(systemToDelete);

      final List<Map<String, dynamic>> updatedIrrigationSystemsData =
          irrigationSystems
              .map((irrigationSystem) => irrigationSystem.toMap())
              .toList();

      await firestore.collection('places').doc(widget.id).update({
        'irrigationSystems': updatedIrrigationSystemsData,
      });
    } catch (e) {
      debugPrint('Error deleting irrigation system from Firestore: $e');
    }
  }

  Future<void> fetchIrrigationSystems() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final irrigationSystemsData =
            placeDocument.data()?['irrigationSystems'];

        if (irrigationSystemsData != null) {
          List<IrrigationSystem> loadedIrrigationSystems =
              (irrigationSystemsData as List)
                  .map((system) => IrrigationSystem.fromMap(system))
                  .toList();
          setState(() {
            irrigationSystems = loadedIrrigationSystems;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading irrigation systems data from Firestore: $e');
    }
  }
}
