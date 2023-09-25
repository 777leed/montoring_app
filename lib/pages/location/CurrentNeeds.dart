import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentNeedsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const CurrentNeedsPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<CurrentNeedsPage> createState() => _CurrentNeedsPageState();
}

class _CurrentNeedsPageState extends State<CurrentNeedsPage> {
  Map<String, dynamic>? neededSupplies;

  TextEditingController tentsController = TextEditingController();
  TextEditingController blanketsController = TextEditingController();
  TextEditingController cushionsController = TextEditingController();
  TextEditingController palletsController = TextEditingController();
  String selectedFood = 'Unknown';
  String selectedConstructionMaterials = 'Unknown';
  String selectedHygieneProducts = 'Unknown';
  String selectedMedicine = 'Unknown';

  @override
  void initState() {
    super.initState();

    fetchSuppliesFromFirestore();
  }

  Future<void> fetchSuppliesFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      setState(() {
        neededSupplies = Map<String, dynamic>.from(
          placeDocument.data()?['neededSupplies'] ?? {},
        );

        tentsController.text = neededSupplies?['Tents'] ?? '0';
        blanketsController.text = neededSupplies?['Blankets'] ?? '0';
        cushionsController.text = neededSupplies?['Cushions'] ?? '0';
        palletsController.text = neededSupplies?['Pallets'] ?? '0';

        selectedFood = neededSupplies?['Food'] ?? 'Unknown';
        selectedConstructionMaterials =
            neededSupplies?['Construction Materials for Building Rehab'] ??
                'Unknown';
        selectedHygieneProducts =
            neededSupplies?['Hygiene Products'] ?? 'Unknown';
        selectedMedicine = neededSupplies?['Medicine/First Aid'] ?? 'Unknown';
      });
    }
  }

  void _showSuppliesDialog() {
    String localSelectedFood = selectedFood;
    String localSelectedConstructionMaterials = selectedConstructionMaterials;
    String localSelectedHygieneProducts = selectedHygieneProducts;
    String localSelectedMedicine = selectedMedicine;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Supplies Information'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Tents', tentsController),
                    _buildTextField('Blankets', blanketsController),
                    _buildTextField('Cushions', cushionsController),
                    _buildTextField('Pallets', palletsController),
                    SizedBox(
                      height: 10,
                    ),
                    _buildDropdownField('Food', localSelectedFood, (value) {
                      setState(() {
                        localSelectedFood = value;
                      });
                    }),
                    _buildDropdownField(
                        'Construction Materials for Building Rehab',
                        localSelectedConstructionMaterials, (value) {
                      setState(() {
                        localSelectedConstructionMaterials = value;
                      });
                    }),
                    _buildDropdownField(
                        'Hygiene Products', localSelectedHygieneProducts,
                        (value) {
                      setState(() {
                        localSelectedHygieneProducts = value;
                      });
                    }),
                    _buildDropdownField(
                        'Medicine/First Aid', localSelectedMedicine, (value) {
                      setState(() {
                        localSelectedMedicine = value;
                      });
                    }),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFood = localSelectedFood;
                      selectedConstructionMaterials =
                          localSelectedConstructionMaterials;
                      selectedHygieneProducts = localSelectedHygieneProducts;
                      selectedMedicine = localSelectedMedicine;
                    });
                    _updateSupplies();
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      controller: controller,
    );
  }

  Widget _buildDropdownField(
      String labelText, String selectedValue, void Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16.0),
        ),
        DropdownButton<String>(
          value: selectedValue,
          onChanged: (newValue) {
            onChanged(newValue!);
          },
          items: <String>['Unknown', 'Low', 'Moderate', 'High']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Normal Supplies"),
      ),
      body: neededSupplies != null
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSupplyTile('Tents', 'Tents'),
                    _buildSupplyTile('Blankets', 'Blankets'),
                    _buildSupplyTile('Cushions', 'Cushions'),
                    _buildSupplyTile('Pallets', 'Pallets'),
                    _buildSupplyTile('Food', 'Food'),
                    _buildSupplyTile(
                      'Construction Materials for Building Rehab',
                      'Construction Materials for Building Rehab',
                    ),
                    _buildSupplyTile('Hygiene Products', 'Hygiene Products'),
                    _buildSupplyTile(
                      'Medicine/First Aid',
                      'Medicine/First Aid',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSuppliesDialog();
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildSupplyTile(String title, String supplyKey) {
    return ListTile(
      title: Text(title),
      subtitle: Text(neededSupplies?[supplyKey] ?? 'Unknown'),
    );
  }

  Future<void> _updateSupplies() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedSuppliesData = {
        'Tents': tentsController.text,
        'Blankets': blanketsController.text,
        'Cushions': cushionsController.text,
        'Pallets': palletsController.text,
        'Food': selectedFood,
        'Construction Materials for Building Rehab':
            selectedConstructionMaterials,
        'Hygiene Products': selectedHygieneProducts,
        'Medicine/First Aid': selectedMedicine,
      };

      await firestore.collection('places').doc(widget.id).update({
        'neededSupplies': updatedSuppliesData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Supplies updated successfully'),
        ),
      );
      await fetchSuppliesFromFirestore();
    } catch (e) {
      print('Error updating supplies in Firestore: $e');
    }
  }
}
