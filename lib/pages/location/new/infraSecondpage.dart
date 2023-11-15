import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfrastructureSecondPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const InfrastructureSecondPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _InfrastructureSecondPageState createState() =>
      _InfrastructureSecondPageState();
}

class _InfrastructureSecondPageState extends State<InfrastructureSecondPage> {
  bool? hasRunningWater;
  bool? hasWell;
  bool? hasSinks;
  bool? usesNaturalSources;
  bool? isWaterAvailable;
  bool? isElectricityAvailable;

  String? notAvailableReason;
  String? electricityNotAvailableReason;
  bool? hasInternet;
  bool? hasSatellites;
  bool? hasMobileNetworkTowers;
  late AppLocalizations l;

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    fetchInfrastructureFromFirestore();
  }

  Future<void> fetchInfrastructureFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final infrastructureDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (infrastructureDocument.exists) {
        final data = infrastructureDocument.data()?['infrastructure'];
        setState(() {
          hasRunningWater = data?['hasRunningWater'] ?? false;
          hasWell = data?['hasWell'] ?? false;
          hasSinks = data?['hasSinks'] ?? false;
          usesNaturalSources = data?['usesNaturalSources'] ?? false;
          isWaterAvailable = data?['isWaterAvailable'] ?? true;
          isElectricityAvailable = data?['isElectricityAvailable'] ?? true;

          notAvailableReason = data?['notAvailableReason'] ?? "";
          electricityNotAvailableReason =
              data?['electricityNotAvailableReason'] ?? "";
          hasInternet = data?['hasInternet'] ?? false;
          hasSatellites = data?['hasSatellites'] ?? false;
          hasMobileNetworkTowers = data?['hasMobileNetworkTowers'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error loading infrastructure data from Firestore: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.infrastructurePageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.waterStatusText + ':',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildInfoTile(
                  l.isWaterAvailableQuestion, isWaterAvailable.toString()),
              _buildInfoTile(
                  l.runningWaterLinkQuestion, hasRunningWater.toString()),
              _buildInfoTile(l.hasWellText, hasWell.toString()),
              _buildInfoTile(l.hasSinksText, hasSinks.toString()),
              _buildInfoTile(
                  l.usesNaturalSourcesText, usesNaturalSources.toString()),
              _buildInfoTile(
                  l.notAvailableReasonText, notAvailableReason ?? ""),
              Text(
                l.electricityAndTelecommunicationText + ':',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildInfoTile(
                  l.electricityStatusText, isElectricityAvailable.toString()),
              _buildInfoTile(l.hasInternetText, hasInternet.toString()),
              _buildInfoTile(l.hasSatellitesText, hasSatellites.toString()),
              _buildInfoTile(l.hasMobileNetworkTowersText,
                  hasMobileNetworkTowers.toString()),
              _buildInfoTile(l.electricityNotAvailableReasonText,
                  electricityNotAvailableReason ?? ""),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInfrastructureDialog,
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Flexible(
              child: Text(
            value,
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }

  void _showInfrastructureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l.edit),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCheckboxField(
                        l.hasRunningWaterText, hasRunningWater ?? false,
                        (value) {
                      setState(() {
                        hasRunningWater = value;
                      });
                    }),
                    _buildCheckboxField(l.hasWellText, hasWell ?? false,
                        (value) {
                      setState(() {
                        hasWell = value;
                      });
                    }),
                    _buildCheckboxField(l.hasSinksText, hasSinks ?? false,
                        (value) {
                      setState(() {
                        hasSinks = value;
                      });
                    }),
                    _buildCheckboxField(
                        l.usesNaturalSourcesText, usesNaturalSources ?? false,
                        (value) {
                      setState(() {
                        usesNaturalSources = value;
                      });
                    }),
                    _buildCheckboxField(
                        l.isWaterAvailableText, isWaterAvailable ?? false,
                        (value) {
                      setState(() {
                        isWaterAvailable = value;
                      });
                    }),
                    _buildTextField(
                        l.notAvailableReasonText, notAvailableReason ?? "",
                        (value) {
                      setState(() {
                        notAvailableReason = value;
                      });
                    }),
                    _buildCheckboxField(l.isElectricityAvailableQuestion,
                        isElectricityAvailable ?? false, (value) {
                      setState(() {
                        isElectricityAvailable = value;
                      });
                    }),
                    _buildTextField(l.electricityNotAvailableReasonText,
                        electricityNotAvailableReason ?? "", (value) {
                      setState(() {
                        electricityNotAvailableReason = value;
                      });
                    }),
                    _buildCheckboxField(l.hasInternetText, hasInternet ?? false,
                        (value) {
                      setState(() {
                        hasInternet = value;
                      });
                    }),
                    _buildCheckboxField(
                        l.hasSatellitesText, hasSatellites ?? false, (value) {
                      setState(() {
                        hasSatellites = value;
                      });
                    }),
                    _buildCheckboxField(l.hasMobileNetworkTowersText,
                        hasMobileNetworkTowers ?? false, (value) {
                      setState(() {
                        hasMobileNetworkTowers = value;
                      });
                    }),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _updateInfrastructure();
                    Navigator.of(context).pop();
                  },
                  child: Text(l.update),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCheckboxField(
      String labelText, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _updateInfrastructure() async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('places').doc(widget.id).update({
        'infrastructure.hasRunningWater': hasRunningWater,
        'infrastructure.hasWell': hasWell,
        'infrastructure.hasSinks': hasSinks,
        'infrastructure.usesNaturalSources': usesNaturalSources,
        'infrastructure.isWaterAvailable': isWaterAvailable,
        'infrastructure.isElectricityAvailable': isElectricityAvailable,
        'infrastructure.notAvailableReason': notAvailableReason,
        'infrastructure.electricityNotAvailableReason':
            electricityNotAvailableReason,
        'infrastructure.hasInternet': hasInternet,
        'infrastructure.hasSatellites': hasSatellites,
        'infrastructure.hasMobileNetworkTowers': hasMobileNetworkTowers,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Infrastructure updated successfully'),
        ),
      );
    } catch (e) {
      debugPrint('Error updating infrastructure in Firestore: $e');
    }
  }
}
