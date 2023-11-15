import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandDetailsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const LandDetailsPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _LandDetailsPageState createState() => _LandDetailsPageState();
}

class _LandDetailsPageState extends State<LandDetailsPage> {
  final TextEditingController landSizeController = TextEditingController();
  final TextEditingController irrigatedLandsController =
      TextEditingController();
  final TextEditingController barrenLandsController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController valleyController = TextEditingController();
  final TextEditingController communeController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  bool subsistence = false;
  bool financial = false;
  bool belongsToubkal = false;

  @override
  void initState() {
    super.initState();
    fetchLandDetails();
  }

  @override
  void dispose() {
    landSizeController.dispose();
    irrigatedLandsController.dispose();
    barrenLandsController.dispose();
    villageController.dispose();
    valleyController.dispose();
    communeController.dispose();
    provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.landDetailsPageTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: landSizeController,
                decoration: InputDecoration(labelText: l.landSizeLabelText),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: irrigatedLandsController,
                decoration: InputDecoration(labelText: l.irrigatedLandsLabel),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: barrenLandsController,
                decoration: InputDecoration(labelText: l.barrenLandsLabel),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildCheckboxField(l.subsistenceFarmingText, subsistence,
                  (value) {
                setState(() {
                  subsistence = value!;
                });
              }),
              SizedBox(height: 10),
              _buildCheckboxField(l.financialFarmingText, financial, (value) {
                setState(() {
                  financial = value!;
                });
              }),
              _buildCheckboxField(l.belongsToubkalLabelText, belongsToubkal,
                  (value) {
                setState(() {
                  belongsToubkal = value!;
                });
              }),
              SizedBox(height: 20),
              TextField(
                controller: villageController,
                decoration: InputDecoration(labelText: l.villageLabel),
              ),
              TextField(
                controller: valleyController,
                decoration: InputDecoration(labelText: l.valleyLabel),
              ),
              TextField(
                controller: communeController,
                decoration: InputDecoration(labelText: l.communeLabel),
              ),
              TextField(
                controller: provinceController,
                decoration: InputDecoration(labelText: l.provinceLabel),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateLandDetails();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildCheckboxField(
      String labelText, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _updateLandDetails() async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('places').doc(widget.id).update({
        'landSize': double.parse(landSizeController.text),
        'irrigatedLands': double.parse(irrigatedLandsController.text),
        'barrenLands': double.parse(barrenLandsController.text),
        'subsistence': subsistence,
        'financial': financial,
        'belongsToubkal': belongsToubkal,
        'village': villageController.text,
        'valley': valleyController.text,
        'commune': communeController.text,
        'province': provinceController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Land details updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating land details in Firestore: $e');
    }
  }

  Future<void> fetchLandDetails() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final data = placeDocument.data();
      setState(() {
        landSizeController.text = data?['landSize']?.toString() ?? '';
        irrigatedLandsController.text =
            data?['irrigatedLands']?.toString() ?? '';
        barrenLandsController.text = data?['barrenLands']?.toString() ?? '';
        subsistence = data?['subsistence'] ?? false;
        financial = data?['financial'] ?? false;
        belongsToubkal = data?['belongsToubkal'] ?? false;
        villageController.text = data?['village'] ?? '';
        valleyController.text = data?['valley'] ?? '';
        communeController.text = data?['commune'] ?? '';
        provinceController.text = data?['province'] ?? '';
      });
    }
  }
}
