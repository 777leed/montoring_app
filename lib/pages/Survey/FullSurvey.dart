import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/Survey/BuildingsSurvey.dart';
import 'package:montoring_app/pages/Survey/ContactsSurvey.dart';
import 'package:montoring_app/pages/Survey/CraftsSurvey.dart';
import 'package:montoring_app/pages/Survey/ElectricityTelecomSurvey.dart';
import 'package:montoring_app/pages/Survey/RoadSurvey.dart';
import 'package:montoring_app/pages/Survey/WaterSurvey.dart';
import 'package:montoring_app/pages/Survey/EducationSurvey.dart';
import 'package:montoring_app/pages/Survey/HerbsSurvey.dart';
import 'package:montoring_app/pages/Survey/InfrastructureSurvey.dart';
import 'package:montoring_app/pages/Survey/IrrigationSurvey.dart';
import 'package:montoring_app/pages/Survey/LiveStockSurvey.dart';
import 'package:montoring_app/pages/Survey/NeedsSurvey.dart';
import 'package:montoring_app/pages/Survey/PopulationSurvey.dart';
import 'package:montoring_app/pages/Survey/StatusSurvey.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:montoring_app/pages/Survey/TreesSurvey.dart';
import 'package:montoring_app/pages/Survey/landsurvey.dart';
import 'package:montoring_app/pages/Survey/locationSurvey.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FullSurvey extends StatefulWidget {
  final String? placeId;
  const FullSurvey({Key? key, required this.placeId});
  @override
  _FullSurveyState createState() => _FullSurveyState();
}

class _FullSurveyState extends State<FullSurvey> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late AppLocalizations l;

  final List<Widget> _surveyPages = [
    LocationSurveyPage(),
    StatusSurvey(),
    NeedsSurvey(),
    PopulationSurvey(),
    InfrastructureSurvey(),
    BuildingSurvey(),
    RoadsSurveyPage(),
    WaterSurveyPage(),
    ElectricityTelecomSurveyPage(),
    ContactsSurvey(),
    CraftsSurvey(),
    EducationSurvey(),
    LandsSurvey(),
    TreesSurvey(),
    HerbsSurvey(),
    IrrigationSurvey(),
    LivestockSurvey(),
  ];

  bool _isUpdating = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  Future<void> updatePlaceWithSurveyData() async {
    try {
      setState(() {
        _isUpdating = true;
      });

      final firestore = FirebaseFirestore.instance;

      SurveyDataProvider surveyDataProvider =
          Provider.of<SurveyDataProvider>(context, listen: false);
      var status = surveyDataProvider.selectedStatus;

      List<String> images = surveyDataProvider.imagePaths;
      List<String> urls = [];
      for (var image in images) {
        final fileName = 'place_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final destination = 'place_images/$fileName';

        try {
          final ref =
              firebase_storage.FirebaseStorage.instance.ref(destination);
          await ref.putFile(File(image));
          String imageUrl = await ref.getDownloadURL();
          urls.add(imageUrl);
        } catch (e) {
          debugPrint('Error uploading image: $e');
        }
      }

      Place updatedPlace = Place(
        name: surveyDataProvider.village,
        status: status,
        population: surveyDataProvider.getPopulation(),
        crafts: surveyDataProvider.crafts,
        infrastructure: surveyDataProvider.getInfrastructure(),
        contacts: surveyDataProvider.contacts,
        educationStatistics: surveyDataProvider.getEducationStatistics(),
        images: urls,
        trees: surveyDataProvider.trees,
        irrigationSystems: surveyDataProvider.irrigationSystems,
        animals: surveyDataProvider.livestock,
        myHerbs: surveyDataProvider.herbs,
        irrigatedLands: surveyDataProvider.irrigatedLands,
        landSize: surveyDataProvider.landsize,
        barrenLands: surveyDataProvider.barrenLands,
        subsistence: surveyDataProvider.subsistence,
        financial: surveyDataProvider.financial,
        belongsToubkal: surveyDataProvider.belongsToubkal,
        village: surveyDataProvider.village,
        valley: surveyDataProvider.valley,
        commune: surveyDataProvider.commune,
        province: surveyDataProvider.province,
        myNeeds: surveyDataProvider.needs,
        supplies: [],
      );

      await firestore
          .collection('places')
          .doc(widget.placeId)
          .update(updatedPlace.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Place updated successfully'),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error updating place in Firestore: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Confirm Exit'),
                content: Text('Are you sure you want to quit the survey?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                              Text(l.previousText)
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
                              Text(l.nextText),
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
                        onTap: () async {
                          if (!_isUpdating) {
                            SurveyDataProvider surveyDataProvider =
                                Provider.of<SurveyDataProvider>(context,
                                    listen: false);

                            await updatePlaceWithSurveyData();
                            surveyDataProvider.resetData();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(l.finishText),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check)
                            ],
                          ),
                        ),
                      ),
                    if (_isUpdating)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
