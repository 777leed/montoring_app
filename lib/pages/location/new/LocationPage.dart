import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const LocationPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  late AppLocalizations l;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.place!.name!;
    latitudeController.text = widget.place!.coordinates!.latitude.toString();
    longitudeController.text = widget.place!.coordinates!.longitude.toString();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.editLocationPageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l.placeNameInputLabelText),
            ),
            SizedBox(height: 20),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: l.latitudeInputLabelText),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: l.longitudeInputLabelText),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveLocationChanges();
              },
              child: Text(l.saveChangesButtonText),
            ),
          ],
        ),
      ),
    );
  }

  void _saveLocationChanges() async {
    final String newName = nameController.text;
    final double newLatitude = double.parse(latitudeController.text);
    final double newLongitude = double.parse(longitudeController.text);

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('places').doc(widget.id).update({
        'name': newName,
        'coordinates': {
          'latitude': newLatitude,
          'longitude': newLongitude,
        },
      });

      widget.place!.name = newName;
      widget.place!.coordinates!.latitude = newLatitude;
      widget.place!.coordinates!.longitude = newLongitude;

      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      debugPrint('Error updating place in Firestore: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
