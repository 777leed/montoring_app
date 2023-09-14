// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/Supplies.dart';

import 'package:montoring_app/pages/AuthPage.dart';
import 'package:montoring_app/pages/PlaceDetails.dart';
import 'package:montoring_app/styles.dart';

class DisasterPage extends StatefulWidget {
  const DisasterPage({Key? key});

  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  List<dynamic>? selectedMarker; // Track the selected marker
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  List<List<dynamic>> rawMarkers = [
    [
      "Aouzaln",
      30.7666652,
      -8.3834763,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      "Done",
    ],
    [
      "Agdim",
      31.306596806811783,
      -6.854573726412822,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      "Done",
    ],
    [
      "Tizi n Test ",
      30.64093864522448,
      -8.482904479268882,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      "Done",
    ],
  ];

  Set<Marker> myMarkers = {};

  @override
  void initState() {
    selectedMarker = [];
    loadMarkers();
    super.initState();
  }

  Future<void> addPlaceToFirestore(
    String name,
    double latitude,
    double longitude,
    String status,
  ) async {
    try {
      await firestore.collection('places').add({
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'infrastructure': null, // Initialize with null
        'population': null, // Initialize with null
        'supplies': null, // Initialize with null
      });
      // Refresh your UI to display the new place
      // For example, you can call loadMarkers() to update the markers on the map.
      loadMarkers();
    } catch (e) {
      // Handle errors
      print('Error adding place to Firestore: $e');
    }
  }

  void loadMarkers() async {
    try {
      // Fetch data from Firestore
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      // Create markers based on Firestore data
      final updatedMarkers = <Marker>{};
      for (final place in places) {
        final name = place.get('name');
        final latitude = place.get('latitude');
        final longitude = place.get('longitude');
        final status = place.get('status');

        // Create markers with appropriate icons and information
        final marker = Marker(
          markerId: MarkerId(name),
          position: LatLng(latitude, longitude),
          icon: status == "Done"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
          onTap: () {
            setState(() {
              selectedMarker = [
                Marker(
                  markerId: MarkerId(name),
                  position: LatLng(latitude, longitude),
                  icon: status == "Done"
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                ),
                status, // Store the status in the second element of the list
              ];
            });
          },
        );

        // Add markers to the set
        updatedMarkers.add(marker);
      }

      // Update the markers set
      setState(() {
        myMarkers = updatedMarkers;
      });
    } catch (e) {
      // Handle errors
      print('Error loading markers from Firestore: $e');
    }
  }

  void navigateToDetailPage() {
    if (selectedMarker != null && selectedMarker!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlaceDetails(
            name: selectedMarker![0].markerId.value,
          ),
        ),
      );
    }
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AuthPage()), // Replace AuthPage with your home page class
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateToHomePage(); // Call the function to navigate to the home page
        return false; // Return false to prevent the default back button behavior
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: GoBack(
                  title: "MAP",
                  onTap: () {
                    navigateToHomePage();
                  },
                ),
              ),
              Expanded(
                child: GoogleMap(
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(31.794525, -7.0849336),
                    zoom: 7,
                  ),
                  markers: myMarkers,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedMarker != null &&
                                      selectedMarker!.isNotEmpty
                                  ? selectedMarker![0].markerId.value
                                  : "Select an Area",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.pin_drop_rounded)
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // Show a dialog or navigate to a new page for data entry
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Add a Place'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        TextField(
                                          controller:
                                              nameController, // Add a controller for the name input
                                          decoration: InputDecoration(
                                              labelText: 'Name'),
                                        ),
                                        TextField(
                                          controller:
                                              latitudeController, // Add a controller for the latitude input
                                          decoration: InputDecoration(
                                              labelText: 'Latitude'),
                                          keyboardType: TextInputType.number,
                                        ),
                                        TextField(
                                          controller:
                                              longitudeController, // Add a controller for the longitude input
                                          decoration: InputDecoration(
                                              labelText: 'Longitude'),
                                          keyboardType: TextInputType.number,
                                        ),
                                        TextField(
                                          controller:
                                              statusController, // Add a controller for the name input
                                          decoration: InputDecoration(
                                              labelText: 'Current Status'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        // Get the values from the text fields and call the function to add to Firestore
                                        final name = nameController.text;
                                        final status = statusController.text;

                                        final latitudeText =
                                            latitudeController.text;
                                        final longitudeText =
                                            longitudeController.text;

                                        if (latitudeText.isNotEmpty &&
                                            longitudeText.isNotEmpty &&
                                            name.isNotEmpty &&
                                            status.isNotEmpty) {
                                          final latitude =
                                              double.parse(latitudeText);
                                          final longitude =
                                              double.parse(longitudeText);
                                          addPlaceToFirestore(name, latitude,
                                              longitude, status);
                                          Navigator.of(context).pop();
                                        } else {
                                          // Handle the case where latitude or longitude is empty
                                          print(
                                              'Latitude or longitude is empty.');
                                        }

// Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: CustomColors.mainColor),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: categorieButton(
                            text: selectedMarker != null &&
                                    selectedMarker!.isNotEmpty
                                ? "Status: ${selectedMarker![1]}"
                                : "Status: Invalid",
                            icon: Icon(
                              Icons.not_interested_outlined,
                              color: Colors.white,
                            ),
                            color: Colors.grey.shade500,
                            onTap: () {
                              // Handle status change for the selected marker
                              if (selectedMarker != null &&
                                  selectedMarker!.isNotEmpty) {
                                // You can update the status for the selected marker here
                                // For example:
                                // selectedMarker![1] = "New Status";
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: categorieButton(
                            text: "Edit Area",
                            icon: Icon(
                              Icons.edit_location_alt_sharp,
                              color: Colors.white,
                            ),
                            color: CustomColors.mainColor,
                            onTap: () {
                              navigateToDetailPage();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
