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

  TextEditingController displacedController = TextEditingController();
  TextEditingController deathController = TextEditingController();
  TextEditingController injuredController = TextEditingController();
  TextEditingController beforeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchPopulationFromFirestore();
  }

  Future<void> fetchPopulationFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final populationData = placeDocument.data()?['population'];

      if (populationData != null && populationData is Map<String, dynamic>) {
        final population = Population.fromMap(populationData);
        setState(() {
          this.population = population;

          displacedController.text = population.populationDisplaced.toString();
          deathController.text = population.populationDeath.toString();
          injuredController.text = population.populationInjured.toString();
          beforeController.text =
              population.populationBeforeDisaster.toString();
        });
      } else {
        setState(() {
          this.population = Population(
              populationDisplaced: 0,
              populationDeath: 0,
              populationInjured: 0,
              populationBeforeDisaster: 0);
        });
      }
    }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: 'Total Before Earthquake'),
                    onChanged: (value) {
                      setState(() {
                        population!.populationBeforeDisaster =
                            int.tryParse(value) ?? 0;
                      });
                    },
                    controller: beforeController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Displaced'),
                    onChanged: (value) {
                      setState(() {
                        population!.populationDisplaced =
                            int.tryParse(value) ?? 0;
                      });
                    },
                    controller: displacedController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Death'),
                    onChanged: (value) {
                      setState(() {
                        population!.populationDeath = int.tryParse(value) ?? 0;
                      });
                    },
                    controller: deathController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Injured'),
                    onChanged: (value) {
                      setState(() {
                        population!.populationInjured =
                            int.tryParse(value) ?? 0;
                      });
                    },
                    controller: injuredController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updatePopulation();
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _updatePopulation() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedPopulationData = population!.toMap();

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
