import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Infrastructure.dart'; // Import the Infrastructure model
import 'package:cloud_firestore/cloud_firestore.dart';

class InfrastructurePage extends StatefulWidget {
  final Place? place;
  final String? id;

  const InfrastructurePage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<InfrastructurePage> createState() => _InfrastructurePageState();
}

class _InfrastructurePageState extends State<InfrastructurePage> {
  Infrastructure? infrastructure;

  @override
  void initState() {
    super.initState();

    fetchInfrastructureFromFirestore();
  }

  Future<void> fetchInfrastructureFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final infrastructureData = placeDocument.data()?['infrastructure'];

      if (infrastructureData != null &&
          infrastructureData is Map<String, dynamic>) {
        final infrastructure = Infrastructure.fromMap(infrastructureData);
        setState(() {
          this.infrastructure = infrastructure;
        });
      } else {
        setState(() {
          this.infrastructure = Infrastructure(
            homeStatistics: [0, 0, 0, 0],
            schoolStatistics: [0, 0, 0, 0],
            mosqueStatistics: [0, 0, 0, 0],
            roadStatistics: [0, 0, 0, 0],
            storeStatistics: [0, 0, 0, 0],
          );
        });
      }
    }
  }

  void _showInfrastructureDialog(String infrastructureType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$infrastructureType Statistics'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int index = 0; index < 4; index++)
                  _buildTextField(
                    _getLabelText(index),
                    infrastructureType,
                    index,
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateInfrastructure();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  String _getLabelText(int index) {
    switch (index) {
      case 0:
        return 'Total Before Earthquake';
      case 1:
        return 'Lost';
      case 2:
        return 'Unstable & Need Rehab';
      case 3:
        return 'Stable';
      default:
        return '';
    }
  }

  Widget _buildTextField(
    String labelText,
    String infrastructureType,
    int index,
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      onChanged: (value) {
        setState(() {
          if (infrastructure != null) {
            switch (infrastructureType) {
              case 'Home':
                infrastructure!.homeStatistics[index] =
                    int.tryParse(value) ?? 0;
                break;
              case 'School':
                infrastructure!.schoolStatistics[index] =
                    int.tryParse(value) ?? 0;
                break;
              case 'Mosque':
                infrastructure!.mosqueStatistics[index] =
                    int.tryParse(value) ?? 0;
                break;
              case 'Road':
                infrastructure!.roadStatistics[index] =
                    int.tryParse(value) ?? 0;
                break;
              case 'Store':
                infrastructure!.storeStatistics[index] =
                    int.tryParse(value) ?? 0;
                break;
              default:
                break;
            }
          }
        });
      },
      controller: TextEditingController(
        text: _getInfrastructureValue(infrastructureType, index),
      ),
    );
  }

  String _getInfrastructureValue(String type, int index) {
    if (infrastructure != null) {
      switch (type) {
        case 'Home':
          return infrastructure!.homeStatistics[index].toString();
        case 'School':
          return infrastructure!.schoolStatistics[index].toString();
        case 'Mosque':
          return infrastructure!.mosqueStatistics[index].toString();
        case 'Road':
          return infrastructure!.roadStatistics[index].toString();
        case 'Store':
          return infrastructure!.storeStatistics[index].toString();
        default:
          break;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infrastructure"),
      ),
      body: infrastructure != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildInfrastructureTile('Home', Icons.home),
                  _buildInfrastructureTile('School', Icons.school),
                  _buildInfrastructureTile('Mosque', Icons.mosque),
                  _buildInfrastructureTile('Road', Icons.directions),
                  _buildInfrastructureTile('Store', Icons.store),
                  // Add more tiles for other types
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildInfrastructureTile(String infrastructureType, IconData icon) {
    return ListTile(
      title: Text(infrastructureType),
      leading: Icon(icon),
      onTap: () {
        _showInfrastructureDialog(infrastructureType);
      },
    );
  }

  Future<void> _updateInfrastructure() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedInfrastructureData =
          infrastructure!.toMap();

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure': updatedInfrastructureData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Infrastructure updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating infrastructure in Firestore: $e');
    }
  }
}
