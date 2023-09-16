import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Supplies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuppliesPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const SuppliesPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<SuppliesPage> createState() => _SuppliesPageState();
}

class _SuppliesPageState extends State<SuppliesPage> {
  List<Supplies> suppliesList = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchSupplies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplies"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading circle
            )
          : suppliesList.isEmpty
              ? Center(
                  child: Text("No supplies given yet"),
                )
              : ListView.builder(
                  itemCount: suppliesList.length,
                  itemBuilder: (context, index) {
                    final supply = suppliesList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        suppliesList.removeAt(index);
                        deleteSupply(supply);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(supply.supplyName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quantity: ${supply.quantity}"),
                            Text(
                                "Date: ${DateFormat('yyyy-MM-dd').format(supply.date)}"), // Display the date
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplyDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddSupplyDialog(BuildContext context) async {
    final TextEditingController supplyNameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Supply'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: supplyNameController,
                decoration: InputDecoration(labelText: 'Supply Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String supplyName = supplyNameController.text;
                final String quantityText = quantityController.text;

                if (supplyName.isNotEmpty && quantityText.isNotEmpty) {
                  final int quantity = int.parse(quantityText);

                  final Supplies newSupply = Supplies(
                    supplyName: supplyName,
                    quantity: quantity,
                    supplyType: '',
                    date: DateTime.now(), // Set the date to the current date
                  );

                  suppliesList.add(newSupply);

                  await saveUpdatedPlace();

                  // Show snackbar when supply is added
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Supply added'),
                    ),
                  );

                  Navigator.of(context).pop();
                  setState(() {});
                } else {
                  // Show snackbar for incorrect fields
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please verify the input fields.'),
                    ),
                  );
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

      final List<Map<String, dynamic>> updatedSuppliesData =
          suppliesList.map((supply) => supply.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'supplies': updatedSuppliesData,
      });
    } catch (e) {
      print('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteSupply(Supplies supply) async {
    try {
      final firestore = FirebaseFirestore.instance;

      suppliesList.remove(supply);

      // Serialize the updated supplies list
      final List<Map<String, dynamic>> updatedSuppliesData =
          suppliesList.map((supply) => supply.toMap()).toList();

      // Update the place in Firestore
      await firestore.collection('places').doc(widget.id).update({
        'supplies': updatedSuppliesData,
      });

      setState(() {});
    } catch (e) {
      print('Error deleting supply in Firestore: $e');
    }
  }

  Future<void> fetchSupplies() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final suppliesData = placeDocument.data()?['supplies'];

      if (suppliesData != null && suppliesData is List<dynamic>) {
        final supplies = suppliesData
            .map((data) => Supplies.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          suppliesList = supplies;
          isLoading = false; // Set loading state to false after fetching data
        });
      }
    }
  }
}
