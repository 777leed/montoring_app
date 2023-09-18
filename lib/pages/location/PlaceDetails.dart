import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/EditCard.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/pages/location/ContactsPage.dart';
import 'package:montoring_app/pages/Maps/EditPlacePage.dart';
import 'package:montoring_app/pages/location/InfraPage.dart';
import 'package:montoring_app/pages/location/LocationPage.dart';
import 'package:montoring_app/pages/location/NeedsPage.dart';
import 'package:montoring_app/pages/location/PopulationPage.dart';
import 'package:montoring_app/pages/suppliesPage.dart';

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
  List<String> typeList = ['Home', 'School', 'Road', 'Mosque', 'Other'];
  List<String> statusList = ['Unknown', 'Safe', 'Severe', 'Moderate', 'Minor'];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> _showStatusChangeDialog(BuildContext context) async {
    String selectedStatus = widget.place!.status;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Current Status'),
          content: Column(
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
                decoration: InputDecoration(labelText: 'Select Status'),
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
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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
                        title: widget.place!.name,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPlacePage()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SuppliesPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: "Supplies\nGiven",
                                img: "Assets/images/supplies.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
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
                                title: "Population\nStatus",
                                img: "Assets/images/groups.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Flexible(
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
                                title: "Infrastruc\nture Status",
                                img: "Assets/images/construction.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                _showStatusChangeDialog(context);
                              },
                              child: EditCard(
                                title: "Current\nStatus",
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
                          Flexible(
                            child: GestureDetector(
                              child: EditCard(
                                title: "Analytics",
                                img: "Assets/images/analytics.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NeedsPage(
                                      place: widget.place,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: EditCard(
                                title: "Needs",
                                img: "Assets/images/expectation.png",
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
                          Flexible(
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
                                title: "Edit\nContacts",
                                img: "Assets/images/contacts.png",
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
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
                                title: "Edit\nLocation",
                                img: "Assets/images/map.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
