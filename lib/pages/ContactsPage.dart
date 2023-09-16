import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const ContactsPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contacts> contactsList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : contactsList.isEmpty
              ? Center(
                  child: Text("No contacts added yet"),
                )
              : ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (context, index) {
                    final contact = contactsList[index];
                    return Dismissible(
                      key: UniqueKey(), // Unique key for each contact
                      onDismissed: (direction) {
                        // Remove the contact from the local list
                        contactsList.removeAt(index);
                        // Delete the contact from Firestore
                        deleteContact(contact);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                      child: ListTile(
                        title: Text(contact.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Phone: ${contact.phoneNumber}"),
                            Text("Email: ${contact.email}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddContactDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final String phoneNumber = phoneNumberController.text;
                final String email = emailController.text;

                if (name.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  final Contacts newContact = Contacts(
                    name: name,
                    phoneNumber: phoneNumber,
                    email: email,
                  );

                  // Add the new contact to the local list
                  contactsList.add(newContact);

                  // Save the updated contacts list to Firestore within the place document
                  await saveUpdatedPlace();

                  // Show a snackbar when a contact gets added
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contact added successfully'),
                    ),
                  );

                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {});
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUpdatedPlace() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Serialize the updated contacts list
      final List<Map<String, dynamic>> updatedContactsData =
          contactsList.map((contact) => contact.toMap()).toList();

      // Update the place in Firestore
      await firestore.collection('places').doc(widget.id).update({
        'contacts': updatedContactsData,
      });
    } catch (e) {
      print('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteContact(Contacts contactToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Remove the contact from the local list
      contactsList.remove(contactToDelete);

      // Serialize the updated contacts list
      final List<Map<String, dynamic>> updatedContactsData =
          contactsList.map((contact) => contact.toMap()).toList();

      // Update the place in Firestore
      await firestore.collection('places').doc(widget.id).update({
        'contacts': updatedContactsData,
      });

      setState(() {});
    } catch (e) {
      print('Error deleting contact in Firestore: $e');
    }
  }

  Future<void> fetchContacts() async {
    final firestore = FirebaseFirestore.instance;
    final placeDocument =
        await firestore.collection('places').doc(widget.id).get();

    if (placeDocument.exists) {
      final contactsData = placeDocument.data()?['contacts'];

      if (contactsData != null && contactsData is List<dynamic>) {
        final contacts = contactsData
            .map((data) => Contacts.fromMap(data as Map<String, dynamic>))
            .toList();
        setState(() {
          contactsList = contacts; // Update the local list
          isLoading = false; // Data fetched, set isLoading to false
        });
      } else {
        setState(() {
          isLoading = false; // Data not found, set isLoading to false
        });
      }
    }
  }
}
