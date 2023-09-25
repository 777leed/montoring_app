import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/pages/Maps/AddPlacePage.dart';
import 'package:montoring_app/pages/Survey/ContactsSurvey.dart';
import 'package:montoring_app/pages/Survey/ImageImport.dart';
import 'package:montoring_app/pages/Survey/InfrastructureSurvey.dart';
import 'package:montoring_app/pages/Survey/PopulationSurvey.dart';
import 'package:montoring_app/pages/Survey/StatusSurvey.dart';
import 'package:montoring_app/pages/Survey/SuppliesAvailable.dart';
import 'package:montoring_app/pages/Survey/SuppliesNeeded.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:provider/provider.dart';

class FullSurvey extends StatefulWidget {
  final String? placeId;
  const FullSurvey({Key? key, required this.placeId});
  @override
  _FullSurveyState createState() => _FullSurveyState();
}

class _FullSurveyState extends State<FullSurvey> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _surveyPages = [
    StatusSurvey(),
    SuppliesAvailablePage(),
    SuppliesNeededPage(),
    PopulationSurvey(),
    InfrastructureSurvey(),
    ContactsSurvey(),
    ImageUploadPage()
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> updatePlaceWithSurveyData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      print(widget.placeId);
      SurveyDataProvider surveyDataProvider =
          Provider.of<SurveyDataProvider>(context, listen: false);

      var contactsList = surveyDataProvider.contacts;
      var status = surveyDataProvider.selectedStatus;
      var currentSupplies = surveyDataProvider.currentSupplies;
      var neededSupplies = surveyDataProvider.neededSupplies;

      final List<Map<String, dynamic>> updatedContactsData =
          contactsList.map((contact) => contact.toMap()).toList();

      await firestore.collection('places').doc(widget.placeId).update({
        'contacts': updatedContactsData,
        'status': status,
        'currentSupplies': currentSupplies,
        'neededSupplies': neededSupplies,
      });

      final Infrastructure infrastructure =
          surveyDataProvider.getInfrastructure();
      final Population population = surveyDataProvider.getPopulation();

      await firestore.collection('places').doc(widget.placeId).update({
        'infrastructure': infrastructure.toMap(),
        'population': population.toMap(),
      });
      List<String> images = surveyDataProvider.imagePaths;
      String imageUrl = '';
      List<String> urls = [];
      for (var image in images) {
        final fileName = 'place_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final destination = 'place_images/$fileName';

        try {
          final ref =
              firebase_storage.FirebaseStorage.instance.ref(destination);
          await ref.putFile(File(image));
          imageUrl = await ref.getDownloadURL();
          urls.add(imageUrl);
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
      await firestore.collection('places').doc(widget.placeId).update({
        'images': urls.toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Place updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating place in Firestore: $e');
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _surveyPages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _surveyPages[index];
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Previous')
                          ],
                        ),
                      ),
                    ),
                  if (_currentPage < _surveyPages.length - 1)
                    GestureDetector(
                      onTap: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Next'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ),
                  if (_currentPage == _surveyPages.length - 1)
                    GestureDetector(
                      onTap: () {
                        SurveyDataProvider surveyDataProvider =
                            Provider.of<SurveyDataProvider>(context,
                                listen: false);
                        print(surveyDataProvider.toString());
                        updatePlaceWithSurveyData();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPlacePage()), // Replace with your desired page
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Finish'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.check)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
