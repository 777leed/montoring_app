// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:montoring_app/models/EducationStatistics.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/coordinates.dart';
import 'package:montoring_app/pages/Survey/FullSurvey.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationSearch extends StatefulWidget {
  LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _controller = TextEditingController();
  String tokenForSession = '37465';
  List<dynamic> listForPlaces = [];
  bool isAddingPlace = false;
  late AppLocalizations l;

  var uuid = Uuid();
  void makeSuggestion(String input) async {
    String googlePlacesApiKey = "AIzaSyBlvMPztN1xg9-cPsWMo6bhk6E8pVPaPEY";
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';
    var responseResult = await http.get(Uri.parse(request));
    var resultData = responseResult.body.toString();
    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(resultData)['predictions'];
      });
    } else {
      throw Exception("Showing Data Failed");
    }
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }

  Future<void> addPlaceToFirestore(
    String name,
    double latitude,
    double longitude,
    String status,
  ) async {
    setState(() {
      isAddingPlace = true;
    });

    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? currentId;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('coordinates.latitude', isEqualTo: latitude)
          .where('coordinates.longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location already added'),
          ),
        );
      } else {
        final place = Place(
          name: name,
          coordinates: MyCoordinates(latitude: latitude, longitude: longitude),
          status: status,
          supplies: [],
          population: Population.initial(),
          crafts: [],
          infrastructure: Infrastructure.initial(),
          contacts: [],
          educationStatistics: EducationStatistics.initial(),
          addedBy: userId,
          images: [],
          trees: [],
          irrigationSystems: [],
          animals: [],
          myHerbs: [],
          irrigatedLands: 0.0,
          barrenLands: 0.0,
          subsistence: false,
          financial: false,
          belongsToubkal: false,
          landSize: 0.0,
          village: '',
          valley: '',
          commune: '',
          province: '',
          myNeeds: [],
        );

        final Map<String, dynamic> data = place.toFirestore();

        final documentReference =
            await firestore.collection('places').add(data);

        currentId = documentReference.id;

        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullSurvey(placeId: currentId!),
          ),
        );
      }
    } catch (e, stackTrace) {
      setState(() {
        isAddingPlace = false;
      });
      debugPrint('Error adding place to Firestore: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l.searchText,
                  suffixIcon: Icon(Icons.search_rounded),
                ),
              ),
              Expanded(
                child: isAddingPlace
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: listForPlaces.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              List<Location> locations =
                                  await locationFromAddress(
                                      listForPlaces[index]['description']);
                              addPlaceToFirestore(
                                  listForPlaces[index]['description'],
                                  locations.last.latitude,
                                  locations.last.longitude,
                                  "Unknown");
                            },
                            title: Text(listForPlaces[index]["description"]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
