import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/EditCard.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/Maps/HelperMe.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/pages/location/new/ContactsPage.dart';
import 'package:montoring_app/pages/location/new/CraftsPage.dart';
import 'package:montoring_app/pages/location/new/buildingsPage.dart';
import 'package:montoring_app/pages/location/new/educationPage.dart';
import 'package:montoring_app/pages/location/new/herbsPage.dart';
import 'package:montoring_app/pages/location/new/infraSecondpage.dart';
import 'package:montoring_app/pages/location/new/irrigationPage.dart';
import 'package:montoring_app/pages/location/new/landDetailsPage.dart';
import 'package:montoring_app/pages/location/new/livestockPage.dart';
import 'package:montoring_app/pages/location/new/needsPage.dart';
import 'package:montoring_app/pages/location/new/roadsPage.dart';
import 'package:montoring_app/pages/location/new/treesPage.dart';
import 'package:montoring_app/pages/location/new/GalleryPage.dart';
import 'package:montoring_app/pages/location/new/InfraPage.dart';
import 'package:montoring_app/pages/location/new/LocationPage.dart';
import 'package:montoring_app/pages/location/new/PopulationPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceDetails extends StatefulWidget {
  final Place? place;
  final String? id;

  const PlaceDetails({Key? key, required this.place, required this.id})
      : super(key: key);

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  bool isLoading = true;
  late List<String> statusList;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    statusList = [l.unknownText, l.lowText, l.mediumText, l.highText];
    super.didChangeDependencies();
  }

  Future<void> _showStatusChangeDialog(BuildContext context) async {
    String? selectedStatus = widget.place!.status;
    selectedStatus = HelperMe().localTrans(selectedStatus, l);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.currentNeedsStatusQuestion),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                items: statusList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: l.selectedStatusText),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final firestore = FirebaseFirestore.instance;
                await firestore.collection('places').doc(widget.id).update({
                  'status': selectedStatus,
                });
                setState(() {
                  widget.place!.status = selectedStatus;
                });
                Navigator.of(context).pop();
              },
              child: Text(l.save),
            ),
          ],
        );
      },
    );
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoBack(
                        title: StringUtils.capitalize(widget.place!.name!),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WherePage()),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MyNeedsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.needsFilterText + "\n",
                                img: "Assets/images/supplies.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PopulationPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.populationSurveyTitle,
                                img: "Assets/images/groups.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InfrastructurePage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.infrastructurePageTitle + "\n",
                                img: "Assets/images/construction.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _showStatusChangeDialog(context);
                              },
                              child: EditCard(
                                title: l.selectedStatusText,
                                img: "Assets/images/time.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InfrastructureSecondPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.waterAndElectricityText,
                                img: "Assets/images/hydro.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LandDetailsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.landDetailsPageTitle,
                                img: "Assets/images/homeland.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ContactsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.contactsBookTitle.replaceAll(":", ""),
                                img: "Assets/images/contacts.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LocationPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.editLocationPageTitle,
                                img: "Assets/images/map.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GalleryPage(
                                      place: widget.place,
                                      placeId: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: "${l.galleryText}\n",
                                img: "Assets/images/image.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EducationStatisticsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: "${l.educationStatistics}",
                                img: "Assets/images/education.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RoadsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.roadsPageTitle + "\n",
                                img: "Assets/images/road.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TreesPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.treesPageTitle + "\n",
                                img: "Assets/images/tree.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LivestockPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.livestockPageTitle + "\n",
                                img: "Assets/images/farm.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CraftsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.titleCraft + "\n",
                                img: "Assets/images/expectation.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HerbsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.herbsPageTitle + "\n",
                                img: "Assets/images/thyme.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BuildingPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.titleBuildings + "\n",
                                img: "Assets/images/building.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => IrrigationSystemPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: l.irrigationSystemsPageTitle,
                                img: "Assets/images/sprinkler.png",
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
