import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/Place.dart';
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

  Future<void> _exportData(BuildContext context) async {
    setState(() {
      _isExporting = true;
    });

    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();

      final List<Map<String, dynamic>> jsonData = [];

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final Place place = Place.fromFirestore(data);

        final Map<String, dynamic> placeData = place.toFirestore();

        jsonData.add(placeData);
      });

      final String jsonString =
          jsonEncode(jsonData, toEncodable: (dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      });

      final String jsonFileName = 'places_data.json';
      final Directory? directory = await getExternalStorageDirectory();
      final String filePath = '${directory!.path}/$jsonFileName';
      final File file = File(filePath);

      await file.writeAsString(jsonString);

      final Reference storageReference =
          FirebaseStorage.instance.ref().child('exports/$jsonFileName');
      final UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        final String downloadURL = await storageReference.getDownloadURL();

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
              title: Center(child: Text('Exported on: $formattedDate')),
              titleAlignment: ListTileTitleAlignment.center,
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
