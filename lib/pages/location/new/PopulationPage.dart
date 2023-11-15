import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchPopulationFromFirestore();
  }

  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
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
      debugPrint('Error loading population data from Firestore: $e');
    }
  }

  void _showPopulationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.populationSurveyTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPopulationSection(l.generalInfoTitle, Icons.home, [
                  _buildTextField(l.totalPopulationLabelText,
                      population?.totalPopulation.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalPopulation = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.totalFamiliesLabelText,
                      population?.totalFamilies.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalFamilies = int.tryParse(value) ?? 0;
                    });
                  })
                ]),
                _buildPopulationSection(
                    l.currentPopulationSectionTitle, Icons.group, [
                  _buildTextField(
                      l.menLabelText, population?.totalMen.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalMen = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.womenLabelText,
                      population?.totalWomen.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalWomen = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.boysAbove18LabelText,
                      population?.totalOlderBoys.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalOlderBoys = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.boysUnder18LabelText,
                      population?.totalYoungerBoys.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalYoungerBoys = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.girlsAbove18LabelText,
                      population?.totalOlderGirls.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalOlderGirls = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.girlsUnder18LabelText,
                      population?.totalYoungerGirls.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalYoungerGirls = int.tryParse(value) ?? 0;
                    });
                  }),
                ]),
                _buildPopulationSection(l.displacedPopulationText, Icons.home, [
                  _buildTextField(l.menLabelText,
                      population?.totalMenDisplaced.toString() ?? "0", (value) {
                    setState(() {
                      population?.totalMenDisplaced = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.womenLabelText,
                      population?.totalWomenDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalWomenDisplaced =
                          int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.boysText,
                      population?.totalBoysDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalBoysDisplaced = int.tryParse(value) ?? 0;
                    });
                  }),
                  _buildTextField(l.girlsText,
                      population?.totalGirlsDisplaced.toString() ?? "0",
                      (value) {
                    setState(() {
                      population?.totalGirlsDisplaced =
                          int.tryParse(value) ?? 0;
                    });
                  }),
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
              child: Text(l.update),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.populationPageTitle),
      ),
      body: population != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildPopulationSection(
                        l.currentPopulationSectionTitle, Icons.group, [
                      _buildPopulationTile(
                          l.menLabelText, population?.totalMen ?? 0),
                      _buildPopulationTile(
                          l.womenLabelText, population?.totalWomen ?? 0),
                      _buildPopulationTile(l.boysAbove18LabelText,
                          population?.totalOlderBoys ?? 0),
                      _buildPopulationTile(l.boysUnder18LabelText,
                          population?.totalYoungerBoys ?? 0),
                      _buildPopulationTile(l.girlsAbove18LabelText,
                          population?.totalOlderGirls ?? 0),
                      _buildPopulationTile(l.girlsUnder18LabelText,
                          population?.totalYoungerGirls ?? 0),
                    ]),
                    _buildPopulationSection(
                        l.displacedPopulationSectionTitle, Icons.home, [
                      _buildPopulationTile(
                          l.menLabelText, population?.totalMenDisplaced ?? 0),
                      _buildPopulationTile(l.womenLabelText,
                          population?.totalWomenDisplaced ?? 0),
                      _buildPopulationTile(
                          l.boysText, population?.totalBoysDisplaced ?? 0),
                      _buildPopulationTile(
                          l.girlsText, population?.totalGirlsDisplaced ?? 0),
                    ])
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
      subtitle: Text('$value'),
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
          content: Text(l.populationUpdatedSnackbar),
        ),
      );
    } catch (e) {
      debugPrint('Error updating population in Firestore: $e');
    }
  }
}
