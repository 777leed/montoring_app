import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/MyOptions.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/EducationStatistics.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Population.dart';
import 'package:montoring_app/models/coordinates.dart';
import 'package:montoring_app/pages/Maps/HelperMe.dart';
import 'package:montoring_app/pages/Maps/LocationSearch.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/pages/Survey/FullSurvey.dart';
import 'package:montoring_app/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late var dropdownValue;
  Set<Marker> myMarkers = {};
  List<Place> placeListToShow = [];
  List<dynamic> availablePlaces = [];
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late AppLocalizations l;

  @override
  void initState() {
    selectedMarker = [];
    loadMarkers();
    fetchPlaces();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    dropdownValue = l.unknownText;
    super.didChangeDependencies();
  }

  Future<void> fetchPlaces() async {
    try {
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      final placeList = places.map((place) {
        final data = place.data();
        final name = data.containsKey('name') ? data['name'] : '';
        final coordinates = data.containsKey('coordinates')
            ? MyCoordinates(
                latitude: data['coordinates']['latitude'],
                longitude: data['coordinates']['longitude'],
              )
            : null;
        final status = data.containsKey('status') ? data['status'] : '';
        final addedBy = data.containsKey('AddedBy') ? data['AddedBy'] : '';

        return Place(
          name: name,
          coordinates: coordinates,
          status: status,
          supplies: [],
          population: null,
          crafts: [],
          infrastructure: null,
          contacts: [],
          educationStatistics: null,
          addedBy: addedBy,
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
      }).toList();

      setState(() {
        availablePlaces = placeList;
        placeListToShow = placeList;
      });
    } catch (e, stacktrace) {
      debugPrint('Error loading places from Firestore: $e, $stacktrace');
    }
  }

  Future<void> _filterPlaces(String searchText) async {
    FocusScope.of(context).unfocus();
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
                  Text(l.loadingText),
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
              title: Text(l.addCurrentLocationText),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Title(color: Colors.black, child: Text(placeName)),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l.nameInputLabel,
                      ),
                    ),
                    TextFormField(
                      controller: latitudeController,
                      decoration: InputDecoration(
                        labelText: l.latitudeInputLabelText,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: longitudeController,
                      decoration: InputDecoration(
                        labelText: l.longitudeInputLabelText,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l.save),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        nameController.text != "" &&
                        nameController.text.length < 20) {
                      String customName = nameController.text.isNotEmpty
                          ? nameController.text
                          : l.unknownText;
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
                              '${l.currentLocationAddedSnackbar}: $customName'),
                        ),
                      );

                      Navigator.of(context).pop;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.invalidNameOrTooLong),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text(l.cancel),
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
            content: Text(l.locationPermissionsDenied),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error adding current location to Firestore: $e');
    }
  }

  void showdialogg(double latitude, double longitude) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteText),
        content: Text(l.areYouSureDelete),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteMarker(latitude, longitude);
            },
            child: Text(l.deleteText),
          ),
        ],
      ),
    );
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
                    hintText: l.searchForLocationHint,
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
                    String? selectedStatus =
                        HelperMe().localTrans(place.status, l);
                    return ListTile(
                      title: Text(place.name),
                      subtitle: Text("${l.placeStatusText} ${selectedStatus}"),
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
      debugPrint('Error loading places from Firestore: $e');
    }
  }

  Future<void> deleteMarker(double latitude, double longitude) async {
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('coordinates.latitude', isEqualTo: latitude)
          .where('coordinates.longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final placeId = querySnapshot.docs[0].id;

        await firestore.collection('places').doc(placeId).delete();
        selectedMarker = [];

        loadMarkers();
      } else {
        debugPrint(
            'Place not found for latitude: $latitude, longitude: $longitude');
      }
    } catch (e) {
      debugPrint('Error deleting place from Firestore: $e');
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
          .where('coordinates.latitude', isEqualTo: latitude)
          .where('coordinates.longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.locationAlreadyAddedMessage),
          ),
        );
      } else {
        final place = Place(
          id: Uuid().v4(),
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

      loadMarkers();
    } catch (e) {
      debugPrint('Error adding place to Firestore: $e');
    }
  }

  void loadMarkers() async {
    try {
      final placesSnapshot = await firestore.collection('places').get();
      final places = placesSnapshot.docs;

      final updatedMarkers = <Marker>{};
      for (final place in places) {
        final name = place.get('name');
        final latitude = place.get('coordinates')['latitude'];
        final longitude = place.get('coordinates')['longitude'];
        final status = place.get('status');

        BitmapDescriptor markerIcon;
        if (status == l.lowText) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          );
        } else if (status == l.mediumText) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          );
        } else if (status == l.highText) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          );
        } else {
          markerIcon = BitmapDescriptor.defaultMarker;
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
      debugPrint('Error loading markers from Firestore: $e');
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
                      title: l.currentText,
                      onTap: () {
                        Navigator.of(context).pop();

                        addCurrentLocationToFirestore();
                      },
                    ),
                    MyOptions(
                        icon: Icon(Icons.search),
                        title: l.searchText,
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
                        title: l.manualText,
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
      target: LatLng(place.coordinates!.latitude, place.coordinates!.longitude),
      zoom: 15.0,
    );

    _googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      selectedMarker = [
        Marker(
          markerId: MarkerId(place.name),
          position:
              LatLng(place.coordinates!.latitude, place.coordinates!.longitude),
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
                Text(l.loadingText),
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
            title: Text(l.addCurrentLocationText),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l.name,
                    ),
                  ),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      labelText: l.latitudeInputLabelText,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: longitudeController,
                    decoration: InputDecoration(
                      labelText: l.longitudeInputLabelText,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(l.save),
                onPressed: () {
                  String name = nameController.text.trim();
                  if (name.isNotEmpty && name.length != 0 && name.length < 20) {
                    String customName = name.isNotEmpty ? name : l.unknownText;
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
                            '${l.currentLocationAddedSnackbar} $customName'),
                      ),
                    );

                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.verifyFieldsText),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text(l.cancel),
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
          content: Text(l.locationPermissionsDenied),
        ),
      );
    } catch (e) {
      debugPrint('Error adding current location to Firestore: $e');
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
                  title: l.map,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          : l.selectAnAreaText,
                                      style: TextStyle(fontSize: 20),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    selectedMarker != null &&
                                            selectedMarker!.isNotEmpty
                                        ? l.placeStatusText +
                                            HelperMe().localTransNotNull(
                                                selectedMarker![1], l)
                                        : "${l.statusInvalidText}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ],
                              )
                            ]),
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categorieButton(
                          text: l.allAreasButtonText,
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
                          text: l.deleteText,
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.white,
                          ),
                          color: const Color.fromARGB(255, 119, 14, 14),
                          onTap: () {
                            if (selectedMarker != null &&
                                selectedMarker!.isNotEmpty &&
                                selectedMarker![0] != null) {
                              // Your existing code for handling the selected place
                              showdialogg(
                                selectedMarker![0].position.latitude,
                                selectedMarker![0].position.longitude,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l.selectPlaceToDelete),
                                ),
                              );
                            }
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
