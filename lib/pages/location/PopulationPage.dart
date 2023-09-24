import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Population.dart'; // Import the Population model
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

  TextEditingController menBeforeController = TextEditingController();
  TextEditingController womenBeforeController = TextEditingController();
  TextEditingController boysBeforeController = TextEditingController();
  TextEditingController girlsBeforeController = TextEditingController();

  TextEditingController menDeathsController = TextEditingController();
  TextEditingController womenDeathsController = TextEditingController();
  TextEditingController boysDeathsController = TextEditingController();
  TextEditingController girlsDeathsController = TextEditingController();

  TextEditingController menInjuredController = TextEditingController();
  TextEditingController womenInjuredController = TextEditingController();
  TextEditingController boysInjuredController = TextEditingController();
  TextEditingController girlsInjuredController = TextEditingController();

  TextEditingController menDisplacedController = TextEditingController();
  TextEditingController womenDisplacedController = TextEditingController();
  TextEditingController boysDisplacedController = TextEditingController();
  TextEditingController girlsDisplacedController = TextEditingController();

  TextEditingController livestockController = TextEditingController();

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

          menBeforeController.text = population.totalMenBefore.toString();
          womenBeforeController.text = population.totalWomenBefore.toString();
          boysBeforeController.text = population.totalBoysBefore.toString();
          girlsBeforeController.text = population.totalGirlsBefore.toString();

          menDeathsController.text = population.totalMenDeaths.toString();
          womenDeathsController.text = population.totalWomenDeaths.toString();
          boysDeathsController.text = population.totalBoysDeaths.toString();
          girlsDeathsController.text = population.totalGirlsDeaths.toString();

          menInjuredController.text = population.totalMenInjured.toString();
          womenInjuredController.text = population.totalWomenInjured.toString();
          boysInjuredController.text = population.totalBoysInjured.toString();
          girlsInjuredController.text = population.totalGirlsInjured.toString();

          menDisplacedController.text = population.totalMenDisplaced.toString();
          womenDisplacedController.text =
              population.totalWomenDisplaced.toString();
          boysDisplacedController.text =
              population.totalBoysDisplaced.toString();
          girlsDisplacedController.text =
              population.totalGirlsDisplaced.toString();

          livestockController.text =
              population.totalLivestockAnimals.toString();
        });
      } else {
        setState(() {
          this.population = Population(
            totalMenBefore: 0,
            totalWomenBefore: 0,
            totalBoysBefore: 0,
            totalGirlsBefore: 0,
            totalMenDeaths: 0,
            totalWomenDeaths: 0,
            totalBoysDeaths: 0,
            totalGirlsDeaths: 0,
            totalMenInjured: 0,
            totalWomenInjured: 0,
            totalBoysInjured: 0,
            totalGirlsInjured: 0,
            totalMenDisplaced: 0,
            totalWomenDisplaced: 0,
            totalBoysDisplaced: 0,
            totalGirlsDisplaced: 0,
            totalLivestockAnimals: 0,
          );
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildTextField('Total Men Before', menBeforeController),
                    _buildTextField(
                        'Total Women Before', womenBeforeController),
                    _buildTextField('Total Boys Before', boysBeforeController),
                    _buildTextField(
                        'Total Girls Before', girlsBeforeController),
                    _buildTextField('Total Men Deaths', menDeathsController),
                    _buildTextField(
                        'Total Women Deaths', womenDeathsController),
                    _buildTextField('Total Boys Deaths', boysDeathsController),
                    _buildTextField(
                        'Total Girls Deaths', girlsDeathsController),
                    _buildTextField('Total Men Injured', menInjuredController),
                    _buildTextField(
                        'Total Women Injured', womenInjuredController),
                    _buildTextField(
                        'Total Boys Injured', boysInjuredController),
                    _buildTextField(
                        'Total Girls Injured', girlsInjuredController),
                    _buildTextField(
                        'Total Men Displaced', menDisplacedController),
                    _buildTextField(
                        'Total Women Displaced', womenDisplacedController),
                    _buildTextField(
                        'Total Boys Displaced', boysDisplacedController),
                    _buildTextField(
                        'Total Girls Displaced', girlsDisplacedController),
                    _buildTextField(
                        'Total Livestock Animals', livestockController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _updatePopulation();
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      onChanged: (value) {
        setState(() {
          controller.text = value;
        });
      },
      controller: controller,
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
