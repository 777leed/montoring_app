import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyCrafts.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CraftsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const CraftsPage({Key? key, this.place, required this.id}) : super(key: key);

  @override
  _CraftsPageState createState() => _CraftsPageState();
}

class _CraftsPageState extends State<CraftsPage> {
  List<MyCrafts> craftsList = [];
  final TextEditingController typeOfCraftController = TextEditingController();
  final TextEditingController numberOfMenController = TextEditingController();
  final TextEditingController numberOfWomenController = TextEditingController();
  bool isLoading = true;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchCrafts();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    typeOfCraftController.dispose();
    numberOfMenController.dispose();
    numberOfWomenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.titleCraft),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : craftsList.isEmpty
              ? Center(
                  child: Text(l.noCrafts),
                )
              : ListView.builder(
                  itemCount: craftsList.length,
                  itemBuilder: (context, index) {
                    final craft = craftsList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        craftsList.removeAt(index);
                        deleteCraft(craft);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(craft.typeOfCraft),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${l.menLabelText}: ${craft.numberOfMen}"),
                            Text("${l.womenLabelText}: ${craft.numberOfWomen}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCraftDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddCraftDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addCraft),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: typeOfCraftController,
                decoration: InputDecoration(labelText: l.typeOfCraft),
              ),
              TextField(
                controller: numberOfMenController,
                decoration: InputDecoration(labelText: l.numberOfMen),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: numberOfWomenController,
                decoration: InputDecoration(labelText: l.numberOfWomen),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String typeOfCraft = typeOfCraftController.text;
                final int numberOfMen =
                    int.tryParse(numberOfMenController.text) ?? 0;
                final int numberOfWomen =
                    int.tryParse(numberOfWomenController.text) ?? 0;

                if (typeOfCraft.isNotEmpty) {
                  final MyCrafts newCraft = MyCrafts(
                    typeOfCraft: typeOfCraft,
                    numberOfMen: numberOfMen,
                    numberOfWomen: numberOfWomen,
                  );

                  craftsList.add(newCraft);
                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.craftAdded),
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

      final List<Map<String, dynamic>> updatedCraftsData =
          craftsList.map((craft) => craft.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'crafts': updatedCraftsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteCraft(MyCrafts craftToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      craftsList.remove(craftToDelete);

      final List<Map<String, dynamic>> updatedCraftsData =
          craftsList.map((craft) => craft.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'crafts': updatedCraftsData,
      });
    } catch (e) {
      debugPrint('Error deleting craft from Firestore: $e');
    }
  }

  Future<void> fetchCrafts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final craftsData = placeDocument.data()?['crafts'];

        if (craftsData != null) {
          List<MyCrafts> loadedCrafts = (craftsData as List)
              .map((craft) => MyCrafts.fromMap(craft))
              .toList();
          setState(() {
            craftsList = loadedCrafts;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading crafts data from Firestore: $e');
    }
  }
}
