import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:montoring_app/pages/Survey/FullSurvey.dart';
import 'package:uuid/uuid.dart';

class LocationSearch extends StatefulWidget {
  LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _controller = TextEditingController();
  String tokenForSession = '37465';
  List<dynamic> listForPlaces = [];
  var uuid = Uuid();
  void makeSuggestion(String input) async {
    String googlePlacesApiKey = "AIzaSyBlvMPztN1xg9-cPsWMo6bhk6E8pVPaPEY";
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';
    var responseResult = await http.get(Uri.parse(request));
    var resultData = responseResult.body.toString();

    print("Result Data");
    print(resultData);

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(resultData)['predictions'];
      });
    } else {
      throw Exception("Showing Data Failed");
    }
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? currentId;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('latitude', isEqualTo: latitude)
          .where('longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location already added'),
          ),
        );
      } else {
        await firestore.collection('places').add({
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
          'status': status,
          'needs': [],
          'infrastructure': [],
          'population': [],
          'supplies': [],
          'contacts': [],
          'AddedBy': userId,
          'currentSupplies': [],
          'neededSupplies': [],
          'images': []
        }).then((documentSnapshot) {
          currentId = documentSnapshot.id;
          print(currentId);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FullSurvey(placeId: currentId),
            ),
          );
        });
      }
    } catch (e) {
      print('Error adding place to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: "Search", suffixIcon: Icon(Icons.search_rounded)),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: listForPlaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              listForPlaces[index]['description']);
                          addPlaceToFirestore(
                              listForPlaces[index]['description'],
                              locations.last.latitude,
                              locations.last.longitude,
                              "Unknown");
                        },
                        title: Text(listForPlaces[index]["description"]),
                      );
                    }))
          ],
        ),
      )),
    );
  }
}
