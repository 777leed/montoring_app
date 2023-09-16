import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';

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
  Place? selectedPlace;
  String? id;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  var dropdownValue = "Done";
  Set<Marker> myMarkers = {};
  List<String> list = <String>['Done', 'Severe', 'Moderate', 'Minor'];
  List<dynamic> availablePlaces = [];

  @override
  void initState() {
    selectedMarker = [];
    loadMarkers();
    fetchAvailablePlaces(); // Fetch available places when the page loads
    super.initState();
  }

  Future<void> fetchPlaceByName(String placeName) async {
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('name', isEqualTo: placeName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final placeId = querySnapshot.docs[0].id;
        final placeDoc =
            await firestore.collection('places').doc(placeId).get();
        if (placeDoc.exists) {
          final place = placeDoc.data();
          final name = place!['name'];
          final latitude = place['latitude'];
          final longitude = place['longitude'];
          final status = place['status'];
          final needs = List<String>.from(place['needs'] ?? []);

          // Update the state with the selected place information
          setState(() {
            selectedPlace = Place(
              name: name,
              latitude: latitude,
              longitude: longitude,
              status: status,
              needs: needs,
            );
            id = placeId;
          });

          // Navigate to the detail page
          navigateToDetailPage();
        }
      } else {
        print('Place not found for name: $placeName');
      }
    } catch (e) {
      print('Error getting place from Firestore: $e');
    }
  }

  Future<void> updatePlace(Function callback) async {
    if (selectedMarker != null && selectedMarker!.isNotEmpty) {
      final selectedLatitude = selectedMarker![0].position.latitude;
      final selectedLongitude = selectedMarker![0].position.longitude;
      try {
        final querySnapshot = await firestore
            .collection('places')
            .where('latitude', isEqualTo: selectedLatitude)
            .where('longitude', isEqualTo: selectedLongitude)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final placeId = querySnapshot.docs[0].id;

          final placeDoc =
              await firestore.collection('places').doc(placeId).get();
          if (placeDoc.exists) {
            final place = placeDoc.data();
            final name = place!['name'];
            final latitude = place['latitude'];
            final longitude = place['longitude'];
            final status = place['status'];
            final needs = List<String>.from(place['needs'] ?? []);

            // Now, update the state with the selected place information
            setState(() {
              selectedPlace = Place(
                name: name,
                latitude: latitude,
                longitude: longitude,
                status: status,
                needs: needs,
              );
              id = placeId;
            });
            callback();
          }
        } else {
          print(
              'Place not found for latitude: $selectedLatitude, longitude: $selectedLongitude');
        }
      } catch (e) {
        print('Error getting place from Firestore: $e');
      }
    }
  }

  Future<void> deleteMarker(double latitude, double longitude) async {
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('latitude', isEqualTo: latitude)
          .where('longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final placeId = querySnapshot.docs[0].id;

        await firestore.collection('places').doc(placeId).delete();

        loadMarkers();
        fetchAvailablePlaces();
      } else {
        print('Place not found for latitude: $latitude, longitude: $longitude');
      }
    } catch (e) {
      // Handle errors
      print('Error deleting place from Firestore: $e');
    }
  }

  Future<void> selectPlace(
    String name,
    double latitude,
    double longitude,
    String status,
    String placeId,
  ) async {
    try {
      final placeDoc = await firestore.collection('places').doc(placeId).get();
      if (placeDoc.exists) {
        final place = placeDoc.data();
        final needs = List<String>.from(place!['needs'] ?? []);

        // Update the state with the selected place information
        setState(() {
          selectedPlace = Place(
            name: name,
            latitude: latitude,
            longitude: longitude,
            status: status,
            needs: needs,
          );
          id = placeId;
        });
      }
    } catch (e) {
      print('Error selecting place: $e');
    }
  }

  Future<void> addPlaceToFirestore(
    String name,
    double latitude,
    double longitude,
    String status,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('latitude', isEqualTo: latitude)
          .where('longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final place = querySnapshot.docs[0].data();
        final existingStatus = place['status'];
        final placeId = querySnapshot.docs[0].id;
        selectPlace(name, latitude, longitude, existingStatus, placeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location already added'),
          ),
        );
      } else {
        final newDocRef = await firestore.collection('places').add({
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
          'status': status,
          'needs': [],
          'infrastructure': [],
          'population': [],
          'supplies': [],
          'contacts': [],
        });

        selectPlace(name, latitude, longitude, status, newDocRef.id);
        fetchAvailablePlaces();
      }

      // Load updated markers
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

        // Determine the marker color based on the status
        BitmapDescriptor markerIcon;
        switch (status) {
          case 'Done':
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            );
            break;
          case 'Severe':
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            );
            break;
          case 'Moderate':
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            );
            break;
          case 'Minor':
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueYellow,
            );
            break;
          default:
            markerIcon = BitmapDescriptor.defaultMarker;
            break;
        }

        // Create markers with appropriate icons and information
        final marker = Marker(
          markerId: MarkerId(name),
          position: LatLng(latitude, longitude),
          icon: markerIcon, // Set the marker's icon based on status
          onTap: () {
            setState(() {
              selectedMarker = [
                Marker(
                  markerId: MarkerId(name),
                  position: LatLng(latitude, longitude),
                  icon: markerIcon, // Set the marker's icon based on status
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

  void navigateToDetailPage() async {
    await updatePlace(() {});
    if (selectedPlace != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlaceDetails(
            place: selectedPlace,
            id: id,
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

  Future<void> fetchAvailablePlaces() async {
    try {
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      final placesList = places.map((place) => place.get('name')).toList();

      setState(() {
        availablePlaces = placesList;
      });
    } catch (e) {
      print('Error fetching available places: $e');
    }
  }

  Future<void> showPlaceSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Place'),
          content: SingleChildScrollView(
            child: Column(
              children: availablePlaces.map((placeName) {
                return ListTile(
                  title: Text(placeName),
                  onTap: () async {
                    setState(() {
                      selectedMarker = null;
                      selectedPlace = null;
                    });
                    await fetchPlaceByName(placeName);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateToHomePage();
        return false;
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                SizedBox(width: 10),
                                Icon(Icons.pin_drop_rounded)
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  selectedMarker != null &&
                                          selectedMarker!.isNotEmpty
                                      ? "Status: ${selectedMarker![1]}"
                                      : "Status: Invalid",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(), // Add a spacer to push the following buttons to the right
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (selectedMarker != null &&
                                    selectedMarker!.isNotEmpty) {
                                  final selectedLatitude =
                                      selectedMarker![0].position.latitude;
                                  final selectedLongitude =
                                      selectedMarker![0].position.longitude;
                                  deleteMarker(
                                      selectedLatitude, selectedLongitude);
                                  setState(() {
                                    selectedMarker = [];
                                    selectedPlace = null;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Add a Place'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Name'),
                                            ),
                                            TextField(
                                              controller: latitudeController,
                                              decoration: InputDecoration(
                                                  labelText: 'Latitude'),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            TextField(
                                              controller: longitudeController,
                                              decoration: InputDecoration(
                                                  labelText: 'Longitude'),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 20),
                                              alignment: Alignment.center,
                                              height: 60,
                                              width: double.infinity,
                                              child: DropdownMenu<String>(
                                                initialSelection: list.first,
                                                onSelected: (String? value) {
                                                  setState(() {
                                                    dropdownValue = value!;
                                                  });
                                                },
                                                dropdownMenuEntries: list.map<
                                                    DropdownMenuEntry<String>>(
                                                  (String value) {
                                                    return DropdownMenuEntry<
                                                        String>(
                                                      value: value,
                                                      label: value,
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              final name = nameController.text;
                                              final status = dropdownValue;
                                              final latitudeText =
                                                  latitudeController.text;
                                              final longitudeText =
                                                  longitudeController.text;
                                              if (latitudeText.isNotEmpty &&
                                                  longitudeText.isNotEmpty &&
                                                  name.isNotEmpty &&
                                                  status != "") {
                                                final latitude =
                                                    double.parse(latitudeText);
                                                final longitude =
                                                    double.parse(longitudeText);
                                                addPlaceToFirestore(
                                                  name,
                                                  latitude,
                                                  longitude,
                                                  status,
                                                );
                                                Navigator.of(context).pop();
                                                nameController.clear();
                                                latitudeController.clear();
                                                longitudeController.clear();
                                              }
                                            }),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: CustomColors.mainColor,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categorieButton(
                          text: "Select Place",
                          icon: Icon(
                            Icons.place,
                            color: Colors.white,
                          ),
                          color: CustomColors.mainColor,
                          onTap: () {
                            showPlaceSelectionDialog();
                          },
                        ),
                        categorieButton(
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
