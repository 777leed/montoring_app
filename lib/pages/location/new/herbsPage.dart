import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyHerbs.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HerbsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const HerbsPage({Key? key, this.place, required this.id}) : super(key: key);

  @override
  _HerbsPageState createState() => _HerbsPageState();
}

class _HerbsPageState extends State<HerbsPage> {
  List<Myherbs> herbsList = [];
  final TextEditingController nameController = TextEditingController();
  bool isLoading = true;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchHerbs();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.herbsPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : herbsList.isEmpty
              ? Center(
                  child: Text(l.noHerbsAddedText),
                )
              : ListView.builder(
                  itemCount: herbsList.length,
                  itemBuilder: (context, index) {
                    final herb = herbsList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        herbsList.removeAt(index);
                        deleteHerb(herb);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(herb.name),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHerbDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddHerbDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addHerbDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l.herbNameLabelText),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;

                if (name.isNotEmpty) {
                  final Myherbs newHerb = Myherbs(
                    name: name,
                  );

                  herbsList.add(newHerb);
                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.herbAddedSuccessText),
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

      final List<Map<String, dynamic>> updatedHerbsData =
          herbsList.map((herb) => herb.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'myHerbs': updatedHerbsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteHerb(Myherbs herbToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      herbsList.remove(herbToDelete);

      final List<Map<String, dynamic>> updatedHerbsData =
          herbsList.map((herb) => herb.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'myHerbs': updatedHerbsData,
      });
    } catch (e) {
      debugPrint('Error deleting herb from Firestore: $e');
    }
  }

  Future<void> fetchHerbs() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final herbsData = placeDocument.data()?['myHerbs'];

        if (herbsData != null) {
          List<Myherbs> loadedHerbs =
              (herbsData as List).map((herb) => Myherbs.fromMap(herb)).toList();
          setState(() {
            herbsList = loadedHerbs;
            isLoading = false;
          });
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error loading herbs data from Firestore: $e $stacktrace');
    }
  }
}
