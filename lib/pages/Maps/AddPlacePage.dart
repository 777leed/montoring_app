import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/MyOptions.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/Maps/LocationSearch.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/pages/Survey/FullSurvey.dart';
import 'package:montoring_app/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({Key? key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  bool isLoading = false;
  List<dynamic>? selectedMarker;
  Place? selectedPlace;
  String? id;
  String? currentId;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleMapController? _googleMapController;
  TextEditingController searchController = TextEditingController();
  var dropdownValue = "Unknown";
  Set<Marker> myMarkers = {};
  List<Place> placeListToShow = [];

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

  Future<void> _filterPlaces(String searchText) async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final filteredPlaces = (availablePlaces as List<Place>).where((place) {
      return place.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    setState(() {
      placeListToShow = filteredPlaces;
    });
  }

  Future<void> addCurrentLocationToFirestore() async {
    try {
      PermissionStatus status = await Permission.location.status;

      if (status.isGranted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Loading..."),
                ],
              ),
            );
          },
        );

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String placeName = "Unknown Place";

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String street = place.street ?? "";
          String subLocality = place.subLocality ?? "";
          String subAdministrativeArea = place.subAdministrativeArea ?? "";
          String postalCode = place.postalCode ?? "";

          placeName = "$street $subLocality $subAdministrativeArea $postalCode";
        }
        final nameController = TextEditingController();
        final latitudeController =
            TextEditingController(text: position.latitude.toString());
        final longitudeController =
            TextEditingController(text: position.longitude.toString());

        Navigator.of(context).pop();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Current Location'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Title(color: Colors.black, child: Text(placeName)),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Custom Name",
                      ),
                    ),
                    TextFormField(
                      controller: latitudeController,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        nameController.text != "" &&
                        nameController.text.length < 20) {
                      String customName = nameController.text.isNotEmpty
                          ? nameController.text
                          : "unknown";
                      final double newlatitude =
                          double.parse(latitudeController.text);
                      final double newlongitude =
                          double.parse(longitudeController.text);

                      addPlaceToFirestore(
                        customName,
                        newlatitude,
                        newlongitude,
                        dropdownValue,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Current location added as a marker: $customName'),
                        ),
                      );

                      Navigator.of(context).pop;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Name Is Empty or Is too long'),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
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
        selectedMarker = [];

        loadMarkers();
      } else {
        print('Place not found for latitude: $latitude, longitude: $longitude');
      }
    } catch (e) {
      print('Error deleting place from Firestore: $e');
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
          'AddedBy': userId,
          'currentSupplies': [],
          'neededSupplies': [],
          'images': []
        }).then((documentSnapshot) {
          currentId = documentSnapshot.id;
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullSurvey(placeId: currentId),
            ),
          );
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

  void _showOptions() {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyOptions(
                      icon: Icon(Icons.gps_fixed),
                      title: "Current",
                      onTap: () {
                        Navigator.of(context).pop();

                        addCurrentLocationToFirestore();
                      },
                    ),
                    MyOptions(
                        icon: Icon(Icons.search),
                        title: "Search",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LocationSearch(),
                            ),
                          );
                          ;
                        }),
                    MyOptions(
                        icon: Icon(Icons.handyman),
                        title: "Manual",
                        onTap: () {
                          Navigator.of(context).pop();

                          addmManualLocationToFirestore();
                        })
                  ],
                )
              ],
            ),
          ),
        ]);
      },
    );
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

  Future<void> addmManualLocationToFirestore() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          );
        },
      );

      final nameController = TextEditingController();
      final latitudeController = TextEditingController();
      final longitudeController = TextEditingController();

      Navigator.of(context).pop();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Current Location'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Custom Name",
                    ),
                  ),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  String name = nameController.text.trim();
                  if (name.isNotEmpty && name.length != 0 && name.length < 20) {
                    String customName = name.isNotEmpty ? name : "unknown";
                    final double newlatitude =
                        double.parse(latitudeController.text);
                    final double newlongitude =
                        double.parse(longitudeController.text);

                    addPlaceToFirestore(
                      customName,
                      newlatitude,
                      newlongitude,
                      dropdownValue,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Current location added as a marker: $customName'),
                      ),
                    );

                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Verify All the fields'),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permissions denied'),
        ),
      );
    } catch (e) {
      print('Error adding current location to Firestore: $e');
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showOptions();
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
                          text: "All Areas",
                          icon: Icon(
                            Icons.local_attraction,
                            color: Colors.white,
                          ),
                          color: CustomColors.mainColor,
                          onTap: () async {
                            await showPlaceList();
                          },
                        ),
                        categorieButton(
                          text: "Remove Area",
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.white,
                          ),
                          color: const Color.fromARGB(255, 119, 14, 14),
                          onTap: () {
                            deleteMarker(selectedMarker![0].position.latitude,
                                selectedMarker![0].position.longitude);
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
