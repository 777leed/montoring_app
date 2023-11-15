import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      debugPrint('Error loading infrastructure data from Firestore: $e');
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
                _buildTextField(l.totalHomesText,
                    infrastructure?.totalHomes.toString() ?? "0", (value) {
                  setState(() {
                    infrastructure?.totalHomes = int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField(l.unsafeHomesLabel,
                    infrastructure?.totalHomesUnstable.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalHomesUnstable =
                        int.tryParse(value) ?? 0;
                  });
                }),
                _buildTextField(l.remainingHomesLabel,
                    infrastructure?.totalHomesIntact.toString() ?? "0",
                    (value) {
                  setState(() {
                    infrastructure?.totalHomesIntact = int.tryParse(value) ?? 0;
                  });
                }),
                SizedBox(
                  height: 10,
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
              child: Text(l.update),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.infrastructurePageTitle),
      ),
      body: infrastructure != null
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildInfrastructureTile(
                        l.homesLabel, Icon(Icons.home), l.home),
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
          if (type == l.home) ...{
            Text('${l.totalHomesText}: ${infrastructure?.totalHomes ?? 0}'),
            Text(
                '${l.totalUnsafeHomesText}: ${infrastructure?.totalHomesUnstable ?? 0}'),
            Text(
                '${l.remainingHomesText}: ${infrastructure?.totalHomesIntact ?? 0}'),
          } else if (type == "road")
            ...{}
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
      debugPrint('Error updating infrastructure in Firestore: $e');
    }
  }
}
