import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late AppLocalizations l;
  late List<String> prefs;
  late String selectedPref;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    prefs = [l.phoneText, l.whatsappText, l.emailText];
    selectedPref = l.phoneText;
    super.didChangeDependencies();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.contactsBookTitle),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : contactsList.isEmpty
              ? Center(
                  child: Text(l.noContacts),
                )
              : ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (context, index) {
                    final contact = contactsList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        contactsList.removeAt(index);

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
                            Text("${l.phoneText}: ${contact.phoneNumber}"),
                            Text("${l.email}: ${contact.email}"),
                            Text(
                                "${l.preferenceTitle}: ${localTransNotNull(contact.prefered, l)}"),
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

  String localTransNotNull(String selectedStatus, AppLocalizations l) {
    Map<String, String> translations = {
      "Phone": l.phoneText,
      "Email": l.emailText,
      "البريد الإلكتروني": l.emailText,
      "الهاتف": l.phoneText,
      "واتساب": l.whatsappText,
      "Téléphone": l.phoneText,
      "WhatsApp": l.whatsappText,
      "E-mail": l.emailText,
    };

    return translations[selectedStatus] ?? selectedStatus;
  }

  Future<void> _showAddContactDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.addContact),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l.name),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: l.phoneNumber),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: l.email),
                keyboardType: TextInputType.emailAddress,
              ),
              DropdownButtonFormField(
                value: selectedPref.isNotEmpty ? selectedPref : l.phoneText,
                items: prefs.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPref = value as String;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final String phoneNumber = phoneNumberController.text;
                final String email = emailController.text;
                final String prefered = selectedPref;

                if (name.isNotEmpty &&
                    phoneNumber.isNotEmpty &&
                    email.isNotEmpty) {
                  final Contacts newContact = Contacts(
                      name: name,
                      phoneNumber: phoneNumber,
                      email: email,
                      prefered: prefered);

                  contactsList.add(newContact);

                  await saveUpdatedPlace();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.contactAdded),
                    ),
                  );

                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: Text(l.add),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUpdatedPlace() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final List<Map<String, dynamic>> updatedContactsData =
          contactsList.map((contact) => contact.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'contacts': updatedContactsData,
      });
    } catch (e) {
      debugPrint('Error updating place in Firestore: $e');
    }
  }

  Future<void> deleteContact(Contacts contactToDelete) async {
    try {
      final firestore = FirebaseFirestore.instance;

      contactsList.remove(contactToDelete);

      final List<Map<String, dynamic>> updatedContactsData =
          contactsList.map((contact) => contact.toMap()).toList();

      await firestore.collection('places').doc(widget.id).update({
        'contacts': updatedContactsData,
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error deleting contact in Firestore: $e');
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
          contactsList = contacts;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
