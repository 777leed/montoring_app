import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/AuthPage.dart';
import 'package:montoring_app/pages/PlaceDetails.dart';
import 'package:montoring_app/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class DisasterPage extends StatefulWidget {
  const DisasterPage({Key? key});

  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  List<dynamic>? selectedMarker;
  Place? selectedPlace;
  String? id;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  var dropdownValue = "Done";
  Set<Marker> myMarkers = {};
  List<String> list = <String>['Safe', 'Severe', 'Moderate', 'Minor'];
  List<dynamic> availablePlaces = [];
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    selectedMarker = [];
    loadMarkers();
    fetchAvailablePlaces();
    super.initState();
  }

  Future<void> addCurrentLocationToFirestore() async {
    try {
      // Request location permissions
      PermissionStatus status = await Permission.location.request();

      if (status.isGranted) {
        // Get the current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Get the address information based on the coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String placeName =
            "Unknown Place"; // Default value if no valid address components found

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          // Build the place name using address components
          String street = place.street ?? "";
          String subLocality = place.subLocality ?? "";
          String subAdministrativeArea = place.subAdministrativeArea ?? "";
          String postalCode = place.postalCode ?? "";

          placeName =
              "$street, $subLocality, $subAdministrativeArea $postalCode";
        }

        // Add the current location as a marker
        addPlaceToFirestore(
          placeName,
          position.latitude,
          position.longitude,
          dropdownValue,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Current location added as a marker: $placeName'),
          ),
        );
      } else {
        // Handle the case where the user denied location permissions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions denied'),
          ),
        );
      }
    } catch (e) {
      print('Error adding current location to Firestore: $e');
    }
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
          setState(() {
            selectedPlace = Place(
                name: name,
                latitude: latitude,
                longitude: longitude,
                status: status,
                needs: needs,
                addedBy: userId);
            id = placeId;
          });

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

            setState(() {
              selectedPlace = Place(
                  name: name,
                  latitude: latitude,
                  longitude: longitude,
                  status: status,
                  needs: needs,
                  addedBy: userId);
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

        setState(() {
          selectedPlace = Place(
              name: name,
              latitude: latitude,
              longitude: longitude,
              status: status,
              needs: needs,
              addedBy: userId);
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

      loadMarkers();
    } catch (e) {
      print('Error adding place to Firestore: $e');
    }
  }

  void loadMarkers() async {
    try {
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      final updatedMarkers = <Marker>{};
      for (final place in places) {
        final name = place.get('name');
        final latitude = place.get('latitude');
        final longitude = place.get('longitude');
        final status = place.get('status');

        BitmapDescriptor markerIcon;
        switch (status) {
          case 'Safe':
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

        final marker = Marker(
          markerId: MarkerId(name),
          position: LatLng(latitude, longitude),
          icon: markerIcon,
          onTap: () {
            setState(() {
              selectedMarker = [
                Marker(
                  markerId: MarkerId(name),
                  position: LatLng(latitude, longitude),
                  icon: markerIcon,
                ),
                status,
              ];
            });
          },
        );

        updatedMarkers.add(marker);
      }

      setState(() {
        myMarkers = updatedMarkers;
      });
    } catch (e) {
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
      MaterialPageRoute(builder: (context) => AuthPage()),
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
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Add Current Location'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
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
                                          child: Text('Add Current Location'),
                                          onPressed: () {
                                            addCurrentLocationToFirestore();
                                            Navigator.of(context).pop();
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
                                  color: CustomColors.mainColor,
                                ),
                                child: Icon(
                                  Icons.add_location,
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
