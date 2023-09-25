import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfrastructurePage extends StatefulWidget {
  final Place? place;
  final String? id;

  const InfrastructurePage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<InfrastructurePage> createState() => _InfrastructurePageState();
}

class _InfrastructurePageState extends State<InfrastructurePage> {
  Infrastructure? infrastructure;

  @override
  void initState() {
    super.initState();
    fetchInfrastructureFromFirestore();
  }

  Future<void> fetchInfrastructureFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final infrastructureData = placeDocument.data()?['infrastructure'];

        if (infrastructureData != null &&
            infrastructureData is Map<String, dynamic>) {
          final infrastructure = Infrastructure.fromMap(infrastructureData);
          setState(() {
            this.infrastructure = infrastructure;
          });
        } else {
          setState(() {
            this.infrastructure = Infrastructure.initial();
          });
        }
      }
    } catch (e) {
      print('Error loading infrastructure data from Firestore: $e');
    }
  }

  void _showInfrastructureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Infrastructure Statistics'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Total Homes Demolished',
                    infrastructure?.totalHomesDemolished.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalHomesDemolished =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Homes Unstable',
                    infrastructure?.totalHomesUnstable.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalHomesUnstable =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Homes Intact',
                    infrastructure?.totalHomesIntact.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalHomesIntact = int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Schools Demolished',
                    infrastructure?.totalSchoolsDemolished.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalSchoolsDemolished =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Schools Unstable',
                    infrastructure?.totalSchoolsUnstable.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalSchoolsUnstable =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Schools Intact',
                    infrastructure?.totalSchoolsIntact.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalSchoolsIntact =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Stores Demolished',
                    infrastructure?.totalStoresDemolished.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalStoresDemolished =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Stores Unstable',
                    infrastructure?.totalStoresUnstable.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalStoresUnstable =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Stores Intact',
                    infrastructure?.totalStoresIntact.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalStoresIntact =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Mosques Demolished',
                    infrastructure?.totalMosquesDemolished.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalMosquesDemolished =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Mosques Unstable',
                    infrastructure?.totalMosquesUnstable.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalMosquesUnstable =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField('Total Mosques Intact',
                    infrastructure?.totalMosquesIntact.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalMosquesIntact =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildNameField(
                  'Road Name',
                  infrastructure?.roadName ?? "Unknown",
                  (value) {
                    setState(() {
                      infrastructure?.roadName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Road Status",
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: infrastructure?.roadStatus ?? 'Blocked',
                  onChanged: (value) {
                    setState(() {
                      infrastructure?.roadStatus = value!;
                    });
                  },
                  items: <String>['Blocked', 'Demolished', 'Unstable', 'Stable']
                      .map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vehicle Type",
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: infrastructure?.roadVehicleType ?? 'Regular Car',
                  onChanged: (value) {
                    setState(() {
                      infrastructure?.roadVehicleType = value!;
                    });
                  },
                  items: <String>[
                    'Regular Car',
                    '4x4',
                    'Truck',
                    'Motorcycle',
                    'N/A'
                  ].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Electricity Status",
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: infrastructure?.electricityStatus ?? 'Unknown',
                  onChanged: (value) {
                    setState(() {
                      infrastructure?.electricityStatus = value!;
                    });
                  },
                  items: <String>['Available', 'Not Available'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Water Status",
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: infrastructure?.waterStatus ?? 'Unknown',
                  onChanged: (value) {
                    setState(() {
                      infrastructure?.waterStatus = value!;
                    });
                  },
                  items: <String>['Available', 'Not Available'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateInfrastructure();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String labelText, String value, ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildNameField(
      String labelText, String value, ValueChanged<String> onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      controller: TextEditingController(text: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infrastructure"),
      ),
      body: infrastructure != null
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildInfrastructureTile('Homes', Icon(Icons.home), 'home'),
                    _buildInfrastructureTile(
                        "Schools", Icon(Icons.school), 'school'),
                    _buildInfrastructureTile(
                        "Mosques", Icon(Icons.mosque), 'mosque'),
                    _buildInfrastructureTile(
                        "Stores", Icon(Icons.store), 'store'),
                    _buildInfrastructureTile(
                        "Road", Icon(Icons.roundabout_left), 'road'),
                    _buildInfrastructureTile("Water & Electricity",
                        Icon(Icons.energy_savings_leaf), 'we')
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInfrastructureDialog();
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfrastructureTile(
      String infrastructureType, Icon icon, String type) {
    return ListTile(
      title: Text(infrastructureType),
      leading: icon,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == "home") ...{
            Text(
                'Total Demolished: ${infrastructure?.totalHomesDemolished ?? 0}'),
            Text('Total Unstable: ${infrastructure?.totalHomesUnstable ?? 0}'),
            Text('Total Intact: ${infrastructure?.totalHomesIntact ?? 0}'),
          } else if (type == "mosque") ...{
            Text(
                'Total Demolished: ${infrastructure?.totalMosquesDemolished ?? 0}'),
            Text(
                'Total Unstable: ${infrastructure?.totalMosquesUnstable ?? 0}'),
            Text('Total Intact: ${infrastructure?.totalMosquesIntact ?? 0}'),
          } else if (type == "school") ...{
            Text(
                'Total Demolished: ${infrastructure?.totalSchoolsDemolished ?? 0}'),
            Text(
                'Total Unstable: ${infrastructure?.totalSchoolsUnstable ?? 0}'),
            Text('Total Intact: ${infrastructure?.totalSchoolsIntact ?? 0}'),
          } else if (type == "store") ...{
            Text(
                'Total Demolished: ${infrastructure?.totalStoresDemolished ?? 0}'),
            Text('Total Unstable: ${infrastructure?.totalStoresUnstable ?? 0}'),
            Text('Total Intact: ${infrastructure?.totalStoresIntact ?? 0}'),
          } else if (type == "road") ...{
            Text('Road Name: ${infrastructure?.roadName ?? "Unknown"}'),
            Text('Road Status: ${infrastructure?.roadStatus ?? "Unknown"}'),
            Text('Vehicle Type: ${infrastructure?.roadVehicleType ?? "N/A"}'),
          } else if (type == "we") ...{
            Text('Water Status: ${infrastructure?.waterStatus ?? "Unknown"}'),
            Text(
                'Electricity Status: ${infrastructure?.electricityStatus ?? "Unknown"}'),
          }
        ],
      ),
    );
  }

  Future<void> _updateInfrastructure() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedInfrastructureData =
          infrastructure?.toMap() ?? {};

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure': updatedInfrastructureData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Infrastructure updated successfully'),
        ),
      );
    } catch (e) {
      print('Error updating infrastructure in Firestore: $e');
    }
  }
}
