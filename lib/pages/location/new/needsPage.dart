import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/MyNeeds.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyNeedsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const MyNeedsPage({Key? key, this.place, required this.id}) : super(key: key);

  @override
  _MyNeedsPageState createState() => _MyNeedsPageState();
}

class _MyNeedsPageState extends State<MyNeedsPage> {
  List<MyNeeds> needsList = [];
  late String selectedType;
  late AppLocalizations l;
  late String otherText;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    selectedType = l.unknownText;
    otherText = l.otherType;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    fetchNeeds();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    typeController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.myNeedsPageTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : needsList.isEmpty
              ? Center(
                  child: Text(l.noNeedsAddedText),
                )
              : ListView.builder(
                  itemCount: needsList.length,
                  itemBuilder: (context, index) {
                    final need = needsList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        needsList.removeAt(index);
                        deleteNeed(need);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(need.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${l.quantityText} ${need.quantity.toString()}"),
                            Text("${l.typeLabelText}: ${need.needType}"),
                            Text("${l.dateText} ${need.date.toString()}"),
                            Text("${l.commentText} ${need.comment}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNeedDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildDropdownWithStatus(
    String supplyType,
    String selectedStatus,
    List<String> statusOptions,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supplyType,
          style: TextStyle(fontSize: 16.0),
        ),
        DropdownButtonFormField<String>(
          value: selectedStatus,
          onChanged: onChanged,
          items: statusOptions.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _showAddNeedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addNeedDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l.nameInputLabel),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: l.quantityLabel),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: l.commentLabel),
              ),
              SizedBox(height: 16.0),
              buildDropdownWithStatus(
                l.typeLabelText,
                selectedType,
                [
                  l.unknownText,
                  l.foodType,
                  l.hygieneType,
                  l.medicineType,
                  l.constructionType,
                  l.otherType
                ],
                (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              if (selectedType == otherText) ...[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: l.typeLabelText),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String type;
                if (selectedType == otherText) {
                  type = typeController.text;
                } else {
                  type = selectedType;
                }
                final String name = nameController.text;
                final int quantity = int.parse(quantityController.text);
                final String comment = commentController.text;

                if (name.isNotEmpty && quantity > 0 && type.isNotEmpty) {
                  final MyNeeds newNeed = MyNeeds(
                    name: name,
                    quantity: quantity,
                    needType: type,
                    date: DateTime.now(),
                    comment: comment,
                  );

                  needsList.add(newNeed);

                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.needAddedSnackbar),
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

      final List<Map<String, dynamic>> updatedNeedsData =
          needsList.map((need) => need.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'needs': updatedNeedsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteNeed(MyNeeds needToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      needsList.remove(needToDelete);

      final List<Map<String, dynamic>> updatedNeedsData =
          needsList.map((need) => need.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'needs': updatedNeedsData,
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error deleting need in Firestore: $e');
    }
  }

  Future<void> fetchNeeds() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final needsData = placeDocument.data()?['needs'];

      if (needsData != null && needsData is List<dynamic>) {
        final needs = needsData
            .map((data) => MyNeeds.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          needsList = needs;
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
