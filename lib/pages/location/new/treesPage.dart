import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/MyTrees.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TreesPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const TreesPage({Key? key, this.place, required this.id}) : super(key: key);

  @override
  _TreesPageState createState() => _TreesPageState();
}

class _TreesPageState extends State<TreesPage> {
  List<MyTrees> treesList = [];
  final TextEditingController typeController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool isLoading = true;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchTrees();
  }

  @override
  void dispose() {
    typeController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.treesPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : treesList.isEmpty
              ? Center(
                  child: Text(l.noTreesAddedText),
                )
              : ListView.builder(
                  itemCount: treesList.length,
                  itemBuilder: (context, index) {
                    final tree = treesList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        treesList.removeAt(index);
                        deleteTree(tree);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(tree.type),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${l.numberLabelText}: ${tree.number.toString()}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTreeDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddTreeDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addTreeText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: l.typeLabelText),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: l.numberLabelText),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String type = typeController.text;
                final int number = int.parse(numberController.text);

                if (type.isNotEmpty && number > 0) {
                  final MyTrees newTree = MyTrees(
                    type: type,
                    number: number,
                  );

                  treesList.add(newTree);

                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.treeAddedSuccessText),
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

      final List<Map<String, dynamic>> updatedTreesData =
          treesList.map((tree) => tree.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'trees': updatedTreesData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteTree(MyTrees treeToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      treesList.remove(treeToDelete);

      final List<Map<String, dynamic>> updatedTreesData =
          treesList.map((tree) => tree.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'trees': updatedTreesData,
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error deleting tree in Firestore: $e');
    }
  }

  Future<void> fetchTrees() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final treesData = placeDocument.data()?['trees'];

      if (treesData != null && treesData is List<dynamic>) {
        final trees = treesData
            .map((data) => MyTrees.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          treesList = trees;
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
