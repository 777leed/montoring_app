import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:montoring_app/components/categorieButton.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/coordinates.dart';
import 'package:montoring_app/pages/Maps/HelperMe.dart';
import 'package:montoring_app/pages/location/new/PlaceDetails.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Set<Marker> myMarkers = {};
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

  Future<void> updatePlace(Function callback) async {
    if (selectedMarker != null && selectedMarker!.isNotEmpty) {
      final selectedLatitude = selectedMarker![0].position.latitude;
      final selectedLongitude = selectedMarker![0].position.longitude;
      try {
        final querySnapshot = await firestore
            .collection('places')
            .where('coordinates.latitude', isEqualTo: selectedLatitude)
            .where('coordinates.longitude', isEqualTo: selectedLongitude)
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
          debugPrint(
              'Place not found for latitude: $selectedLatitude, longitude: $selectedLongitude');
        }
      } catch (e, stacktrace) {
        debugPrint('Error getting place from Firestore: $e, $stacktrace');
      }
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

  Future<void> _filterPlaces(String searchText) async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final filteredPlaces = (availablePlaces as List<Place>).where((place) {
      return place.name!.toLowerCase().contains(searchText.toLowerCase());
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
                      title: Text(place.name!),
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

  void _goToPlaceOnMap(Place place) {
    setState(() {
      selectedMarker = [
        Marker(
          markerId: MarkerId(place.name!),
          position:
              LatLng(place.coordinates!.latitude, place.coordinates!.longitude),
        ),
        place.status,
      ];
    });
    final cameraPosition = CameraPosition(
      target: LatLng(place.coordinates!.latitude, place.coordinates!.longitude),
      zoom: 15.0,
    );

    _googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
                                SizedBox(width: 10),
                                Icon(Icons.pin_drop_rounded)
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
                          text: l.editAreaButtonText,
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
