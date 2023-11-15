import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/Livestock.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LivestockPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const LivestockPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _LivestockPageState createState() => _LivestockPageState();
}

class _LivestockPageState extends State<LivestockPage> {
  List<Livestock> livestockList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool isLoading = true;
  late AppLocalizations l;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    fetchLivestock();
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.livestockPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : livestockList.isEmpty
              ? Center(
                  child: Text(l.noLivestockAddedText),
                )
              : ListView.builder(
                  itemCount: livestockList.length,
                  itemBuilder: (context, index) {
                    final livestock = livestockList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        livestockList.removeAt(index);
                        deleteLivestock(livestock);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(livestock.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${l.numberInputLabelText}: ${livestock.number.toString()}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLivestockDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddLivestockDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addLivestockDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l.nameInputLabel),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: l.numberInputLabelText),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final int number = int.parse(numberController.text);

                if (name.isNotEmpty && number > 0) {
                  final Livestock newLivestock = Livestock(
                    name: name,
                    number: number,
                  );

                  livestockList.add(newLivestock);

                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.livestockAddedSuccessText),
                    ),
                  );

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

      final List<Map<String, dynamic>> updatedLivestockData =
          livestockList.map((livestock) => livestock.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'animals': updatedLivestockData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteLivestock(Livestock livestockToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      livestockList.remove(livestockToDelete);

      final List<Map<String, dynamic>> updatedLivestockData =
          livestockList.map((livestock) => livestock.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'animals': updatedLivestockData,
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error deleting livestock in Firestore: $e');
    }
  }

  Future<void> fetchLivestock() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final livestockData = placeDocument.data()?['animals'];

      if (livestockData != null && livestockData is List<dynamic>) {
        final livestock = livestockData
            .map((data) => Livestock.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          livestockList = livestock;
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
