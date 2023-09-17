import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  bool _isExporting = false;
// ...

  Future<void> _exportData(BuildContext context) async {
    setState(() {
      _isExporting = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Query all places for the current user from Firebase Firestore
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('AddedBy', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> jsonData = [];

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final Map<String, dynamic> placeData = {
          'Name': data['name'],
          'Latitude': data['latitude'],
          'Longitude': data['longitude'],
          'Status': data['status'],
          'Needs':
              data['needs'] is List ? (data['needs'] as List).join(', ') : '',
        };

        // Check if 'population' data is available
        if (data['population'] is Map<String, dynamic>) {
          final Population population = Population.fromMap(data['population']);
          placeData['Population'] = {
            'populationDisplaced': population.populationDisplaced,
            'populationDeath': population.populationDeath,
            'populationInjured': population.populationInjured,
            'populationBeforeDisaster': population.populationBeforeDisaster,
          };
        }

        // Check if 'infrastructure' data is available
        if (data['infrastructure'] is Map<String, dynamic>) {
          final Infrastructure infrastructure =
              Infrastructure.fromMap(data['infrastructure']);
          placeData['Infrastructure'] = {
            'homeStats': infrastructure.homeStatistics.join(', '),
            'schoolStats': infrastructure.schoolStatistics.join(', '),
            'mosqueStats': infrastructure.mosqueStatistics.join(', '),
            'roadStats': infrastructure.roadStatistics.join(', '),
            'storeStats': infrastructure.storeStatistics.join(', '),
          };
        }

        // Check if 'supplies' data is available
        if (data['supplies'] is List) {
          final List<Map<String, dynamic>> suppliesList =
              (data['supplies'] as List)
                  .map((supply) => Supplies.fromMap(supply ?? {}).toMap())
                  .toList();
          placeData['Supplies'] = suppliesList;
        }

        // Check if 'contacts' data is available
        if (data['contacts'] is List) {
          final List<Map<String, dynamic>> contactsList =
              (data['contacts'] as List)
                  .map((contact) => Contacts.fromMap(contact ?? {}).toMap())
                  .toList();
          placeData['Contacts'] = contactsList;
        }

        jsonData.add(placeData);
      });

      // Convert DateTime objects to ISO 8601 strings
      final String jsonString =
          jsonEncode(jsonData, toEncodable: (dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      });

      // Create a JSON file
      final String jsonFileName = 'places_data.json';
      final Directory? directory = await getExternalStorageDirectory();
      final String filePath = '${directory!.path}/$jsonFileName';
      final File file = File(filePath);

      await file.writeAsString(jsonString);

      // Upload the JSON file to Firebase Storage
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('exports/$jsonFileName');
      final UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded file
        final String downloadURL = await storageReference.getDownloadURL();

        // Add export record to Firestore
        await FirebaseFirestore.instance.collection('exports').add({
          'downloadURL': downloadURL,
          'exportDate': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported and uploaded to Firebase Storage.'),
          ),
        );

        setState(() {
          _isExporting = false;
        });
      });
    } catch (e) {
      print('Error exporting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting data.'),
        ),
      );

      setState(() {
        _isExporting = false;
      });
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Data Export'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _isExporting ? null : () => _exportData(context),
              child: Text('Export Data & Upload'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isExporting
                  ? Center(child: CircularProgressIndicator())
                  : _buildExportHistory(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportHistory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('exports').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No export history available.'),
          );
        }

        final exportDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: exportDocs.length,
          itemBuilder: (context, index) {
            final exportData = exportDocs[index].data() as Map<String, dynamic>;
            final downloadURL = exportData['downloadURL'];
            final exportDate = exportData['exportDate'] as Timestamp;
            final formattedDate = DateTime.fromMillisecondsSinceEpoch(
                    exportDate.millisecondsSinceEpoch)
                .toString();

            return ListTile(
              title: Text('Exported on: $formattedDate'),
              subtitle: TextButton(
                onPressed: () {
                  _launchUrl(downloadURL);
                },
                child: Text('Download Link'),
              ),
            );
          },
        );
      },
    );
  }
}
