import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with existing data
    nameController.text = widget.place!.name;
    latitudeController.text = widget.place!.latitude.toString();
    longitudeController.text = widget.place!.longitude.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Place Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveLocationChanges();
              },
              child: Text('Save Changes'),
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
        'latitude': newLatitude,
        'longitude': newLongitude,
      });

      // Update the local place object
      widget.place!.name = newName;
      widget.place!.latitude = newLatitude;
      widget.place!.longitude = newLongitude;

      // Navigate back to the previous page
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating place in Firestore: $e');
      // Handle error here
    }
  }
}
