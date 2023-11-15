import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/location/new/PlaceDetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankPlacesPage extends StatefulWidget {
  @override
  _RankPlacesPageState createState() => _RankPlacesPageState();
}

class _RankPlacesPageState extends State<RankPlacesPage> {
  List<Place> places = [];
  bool isLoading = true;
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    selectedFilter = AppLocalizations.of(context)!.needsFilterText;
    fetchPlaces(context);

    super.didChangeDependencies();
  }

  Future<String?> getPlaceId(double latitude, double longitude) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('places')
          .where('coordinates.latitude', isEqualTo: latitude)
          .where('coordinates.longitude', isEqualTo: longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].id;
      } else {
        print('Place not found for latitude: $latitude, longitude: $longitude');
        return null;
      }
    } catch (e, stacktrace) {
      print('Error getting place ID from Firestore: $e, $stacktrace');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(l.rankPlacesTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : places.isEmpty
                  ? Center(
                      child: Text(l.noData),
                    )
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        final latitude = place.coordinates!.latitude;
                        final longitude = place.coordinates!.longitude;
                        String? selectedStatus = place.status;
                        if (selectedStatus == "Unknown" ||
                            selectedStatus == "غير معروف") {
                          selectedStatus = l.unknownText;
                        } else if (selectedStatus == "Low" ||
                            selectedStatus == "منخفض") {
                          selectedStatus = l.lowText;
                        } else if (selectedStatus == "Medium" ||
                            selectedStatus == "متوسط") {
                          selectedStatus = l.mediumText;
                        } else if (selectedStatus == "High" ||
                            selectedStatus == "عالي") {
                          selectedStatus = l.highText;
                        }
                        return ListTile(
                          leading: Text((index + 1).toString()),
                          onTap: () async {
                            String? id = await getPlaceId(latitude, longitude);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceDetails(
                                  place: place,
                                  id: id,
                                ),
                              ),
                            );
                          },
                          title: Text(place.name),
                          subtitle:
                              Text('${l.placeStatusText} ${selectedStatus}'),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterOptions();
        },
        child: Icon(Icons.filter_alt),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          final l = AppLocalizations.of(context)!;

          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(LineIcons.shoppingBag),
                  title: Text(l.needsFilterText),
                  onTap: () {
                    setState(() {
                      selectedFilter = l.needsFilterText;
                      Navigator.pop(context);
                      fetchPlaces(context);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text(l.totalPopulationLabelText),
                  onTap: () {
                    setState(() {
                      selectedFilter = l.totalPopulationFilterText;
                      Navigator.pop(context);
                      fetchPlaces(context);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(LineIcons.mountain),
                  title: Text(l.belongsToubkalLabelText),
                  onTap: () {
                    setState(() {
                      selectedFilter = l.toubkalFilterText;
                      Navigator.pop(context);
                      fetchPlaces(context);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(LineIcons.damagedHouse),
                  title: Text(l.damagedHousesFilterText),
                  onTap: () {
                    setState(() {
                      selectedFilter = l.damagedHousesFilterText;
                      Navigator.pop(context);
                      fetchPlaces(context);
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> fetchPlaces(BuildContext context) async {
    try {
      final l = AppLocalizations.of(context)!;

      QuerySnapshot? placesSnapshot;
      if (selectedFilter == l.needsFilterText) {
        placesSnapshot = await FirebaseFirestore.instance
            .collection('places')
            .orderBy('needs', descending: true)
            .get();
      } else if (selectedFilter == l.totalPopulationFilterText) {
        placesSnapshot = await FirebaseFirestore.instance
            .collection('places')
            .orderBy('population.totalPopulation', descending: true)
            .get();
      } else if (selectedFilter == l.toubkalFilterText) {
        placesSnapshot = await FirebaseFirestore.instance
            .collection('places')
            .where('belongsToubkal', isEqualTo: true)
            .get();
      } else if (selectedFilter == l.damagedHousesFilterText) {
        placesSnapshot = await FirebaseFirestore.instance
            .collection('places')
            .orderBy('infrastructure.totalHomesUnstable', descending: true)
            .get();
      }
      if (placesSnapshot != null) {
        final List<Place> fetchedPlaces = placesSnapshot.docs.map((place) {
          return Place.fromFirestore(place.data() as Map<String, dynamic>);
        }).toList();

        setState(() {
          places = fetchedPlaces;
          isLoading = false;
        });
      }
    } catch (e, stacktrace) {
      print('Error fetching places: $e, $stacktrace');
    }
  }
}
