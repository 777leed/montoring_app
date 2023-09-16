import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/goback.dart';
import 'package:montoring_app/models/Place.dart';

class NeedsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const NeedsPage({Key? key, required this.place, required this.id})
      : super(key: key);

  @override
  _NeedsPageState createState() => _NeedsPageState();
}

class _NeedsPageState extends State<NeedsPage> {
  TextEditingController _needsController = TextEditingController();
  List<String> needsList = [];
  bool isLoading = true; // Add a loading indicator state

  @override
  void initState() {
    super.initState();
    _fetchNeeds();
  }

  // Function to fetch needs data from Firestore
  void _fetchNeeds() {
    FirebaseFirestore.instance
        .collection('places')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('needs') && data['needs'] is List) {
          setState(() {
            needsList = List<String>.from(data['needs']);
            isLoading = false; // Set loading to false when data is fetched
          });
        }
      }
    });
  }

  // Function to add a new need
  void _addNeed(String need) {
    if (need.isNotEmpty) {
      setState(() {
        needsList.add(need);
      });
      _updateNeedsInFirestore();

      // Show a SnackBar when an item is added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need added: $need'),
        ),
      );
    }
    _needsController.clear();
  }

  // Function to remove a need
  void _removeNeed(String need) {
    setState(() {
      needsList.remove(need);
    });
    _updateNeedsInFirestore();
  }

  // Function to update needs data in Firestore
  void _updateNeedsInFirestore() {
    FirebaseFirestore.instance.collection('places').doc(widget.id).update({
      'needs': needsList,
    });
  }

  @override
  void dispose() {
    _needsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Needs'),
      ),
      body: isLoading
          ? Center(
              // Display a loading indicator while data is being fetched
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Add a New Need:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _needsController,
                            decoration: InputDecoration(
                              hintText: 'Enter a new need',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _addNeed(_needsController.text);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Current Needs:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (needsList.isEmpty) Text('No needs available.'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: needsList
                          .map((need) => _buildNeedTile(need))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNeedTile(String need) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _removeNeed(need);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(need),
      ),
    );
  }
}
