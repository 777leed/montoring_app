import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/location/PlaceDetails.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/styles.dart';

class EditPlacePage extends StatefulWidget {
  const EditPlacePage({Key? key});

  @override
  State<EditPlacePage> createState() => _EditPlacePageState();
}

class _EditPlacePageState extends State<EditPlacePage> {
  bool isLoading = false;
  List<dynamic>? selectedMarker;
  Place? selectedPlace;
  List<Place> placeListToShow = [];
  TextEditingController searchController = TextEditingController();

  String? id;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleMapController? _googleMapController;

  var dropdownValue = "Unknown";
  Set<Marker> myMarkers = {};
  List<String> list = <String>[
    'Unknown',
    'Safe',
    'Severe',
    'Moderate',
    'Minor'
  ];
  List<dynamic> availablePlaces = [];
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    selectedMarker = [];
    loadMarkers();
    fetchPlaces();
    super.initState();
  }

  Future<void> fetchPlaces() async {
    try {
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      final placeList = places.map((place) {
        final name = place.get('name');
        final latitude = place.get('latitude');
        final longitude = place.get('longitude');
        final status = place.get('status');
        final addedby = place.get('AddedBy');

        return Place(
          name: name,
          latitude: latitude,
          longitude: longitude,
          status: status,
          addedBy: addedby,
        );
      }).toList();

      setState(() {
        availablePlaces = placeList;
        placeListToShow = placeList;
      });
    } catch (e) {
      print('Error loading places from Firestore: $e');
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
            final placeData = placeDoc.data() as Map<String, dynamic>;

            setState(() {
              selectedPlace = Place.fromFirestore(placeData);
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
          'AddedBy': userId
        });
      }

      loadMarkers();
      fetchPlaces();
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

  Future<void> _filterPlaces(String searchText) async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final filteredPlaces = (availablePlaces as List<Place>).where((place) {
      return place.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    setState(() {
      placeListToShow = filteredPlaces;
    });
  }

  Future<void> showPlaceList() async {
    try {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {
                    _filterPlaces(value);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search For A Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: CustomColors.mainColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placeListToShow.length,
                  itemBuilder: (context, index) {
                    final place = placeListToShow[index];
                    return ListTile(
                      title: Text(place.name),
                      subtitle: Text("Status: ${place.status}"),
                      onTap: () {
                        Navigator.pop(context);
                        _goToPlaceOnMap(place);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error loading places from Firestore: $e');
    }
  }

  void _goToPlaceOnMap(Place place) {
    final cameraPosition = CameraPosition(
      target: LatLng(place.latitude, place.longitude),
      zoom: 15.0,
    );

    _googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      selectedMarker = [
        Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.latitude, place.longitude),
        ),
        place.status,
      ];
    });
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WherePage()),
    );
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
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController = controller;
                  },
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    selectedMarker != null &&
                                            selectedMarker!.isNotEmpty
                                        ? selectedMarker![0].markerId.value
                                        : "Select an Area",
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categorieButton(
                          text: "All Areas",
                          icon: Icon(
                            Icons.local_attraction,
                            color: Colors.white,
                          ),
                          color: CustomColors.mainColor,
                          onTap: () {
                            showPlaceList();
                          },
                        ),
                        categorieButton(
                          text: "Edit Area",
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          color: const Color.fromARGB(255, 119, 14, 14),
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
