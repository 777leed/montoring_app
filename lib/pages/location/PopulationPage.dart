import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopulationPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const PopulationPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<PopulationPage> createState() => _PopulationPageState();
}

class _PopulationPageState extends State<PopulationPage> {
  Population? population;

  @override
  void initState() {
    super.initState();
    fetchPopulationFromFirestore();
  }

  Future<void> fetchPopulationFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final populationData = placeDocument.data()?['population'];

        if (populationData != null && populationData is Map<String, dynamic>) {
          final population = Population.fromMap(populationData);
          setState(() {
            this.population = population;
          });
        } else {
          setState(() {
            this.population = Population.initial();
          });
        }
      }
    } catch (e) {
      print('Error loading population data from Firestore: $e');
    }
  }

  void _showPopulationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Population Statistics'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPopulationSection('Before Crisis', Icons.group, [
                  _buildTextField(
                      'Men', population?.totalMenBefore.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalMenBefore = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Women', population?.totalWomenBefore.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalWomenBefore = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Boys', population?.totalBoysBefore.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalBoysBefore = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Girls', population?.totalGirlsBefore.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalGirlsBefore = int.tryParse(value) ?? 0;
                    });
                  }),
                ]),
                _buildPopulationSection('Deaths', Icons.warning, [
                  _buildTextField(
                      'Men', population?.totalMenDeaths.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalMenDeaths = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Women', population?.totalWomenDeaths.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalWomenDeaths = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Boys', population?.totalBoysDeaths.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalBoysDeaths = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Girls', population?.totalGirlsDeaths.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalGirlsDeaths = int.tryParse(value) ?? 0;
                    });
                  }),
                ]),
                _buildPopulationSection('Injured', Icons.local_hospital, [
                  _buildTextField(
                      'Men', population?.totalMenInjured.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalMenInjured = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Women', population?.totalWomenInjured.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalWomenInjured = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Boys', population?.totalBoysInjured.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalBoysInjured = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Girls', population?.totalGirlsInjured.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalGirlsInjured = int.tryParse(value) ?? 0;
                    });
                  }),
                ]),
                _buildPopulationSection('Displaced', Icons.home, [
                  _buildTextField(
                      'Men', population?.totalMenDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalMenDisplaced = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField('Women',
                      population?.totalWomenDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalWomenDisplaced =
                          int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(
                      'Boys', population?.totalBoysDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalBoysDisplaced = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField('Girls',
                      population?.totalGirlsDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalGirlsDisplaced =
                          int.tryParse(value) ?? 0;
                    });
                  }),
                ]),
                _buildPopulationSection('Livestock', Icons.pets_rounded, [
                  _buildTextField('Total Livestock Animals',
                      population?.totalLivestockAnimals.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalLivestockAnimals =
                          int.tryParse(value) ?? 0;
                    });
                  })
                ]),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updatePopulation();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String labelText, String value, ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildPopulationSection(
      String sectionName, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(sectionName),
          leading: Icon(icon),
        ),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Population"),
      ),
      body: population != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildPopulationSection('Before Crisis', Icons.group, [
                      _buildPopulationTile(
                          'Men', population?.totalMenBefore ?? 0),
                      _buildPopulationTile(
                          'Women', population?.totalWomenBefore ?? 0),
                      _buildPopulationTile(
                          'Boys', population?.totalBoysBefore ?? 0),
                      _buildPopulationTile(
                          'Girls', population?.totalGirlsBefore ?? 0),
                    ]),
                    _buildPopulationSection('Deaths', Icons.warning, [
                      _buildPopulationTile(
                          'Men', population?.totalMenDeaths ?? 0),
                      _buildPopulationTile(
                          'Women', population?.totalWomenDeaths ?? 0),
                      _buildPopulationTile(
                          'Boys', population?.totalBoysDeaths ?? 0),
                      _buildPopulationTile(
                          'Girls', population?.totalGirlsDeaths ?? 0),
                    ]),
                    _buildPopulationSection('Injured', Icons.local_hospital, [
                      _buildPopulationTile(
                          'Men', population?.totalMenInjured ?? 0),
                      _buildPopulationTile(
                          'Women', population?.totalWomenInjured ?? 0),
                      _buildPopulationTile(
                          'Boys', population?.totalBoysInjured ?? 0),
                      _buildPopulationTile(
                          'Girls', population?.totalGirlsInjured ?? 0),
                    ]),
                    _buildPopulationSection('Displaced', Icons.home, [
                      _buildPopulationTile(
                          'Men', population?.totalMenDisplaced ?? 0),
                      _buildPopulationTile(
                          'Women', population?.totalWomenDisplaced ?? 0),
                      _buildPopulationTile(
                          'Boys', population?.totalBoysDisplaced ?? 0),
                      _buildPopulationTile(
                          'Girls', population?.totalGirlsDisplaced ?? 0),
                    ]),
                    _buildPopulationSection('Livestock', Icons.pets, [
                      _buildPopulationTile('Total Livestock Animals',
                          population?.totalLivestockAnimals ?? 0),
                    ]),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPopulationDialog();
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildPopulationTile(String populationType, int value) {
    return ListTile(
      title: Text(populationType),
      subtitle: Text('Total: $value'),
    );
  }

  Future<void> _updatePopulation() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedPopulationData =
          population?.toMap() ?? {};

      await firestore.collection('places').doc(widget.id).update({
        'population': updatedPopulationData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Population updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating population in Firestore: $e');
    }
  }
}
