import 'package:flutter/material.dart';
import 'package:montoring_app/models/Contacts.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsSurvey extends StatefulWidget {
  @override
  _ContactsSurveyState createState() => _ContactsSurveyState();
}

class _ContactsSurveyState extends State<ContactsSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedPreference;
  late List<String> preferences;

  List<Contacts> contactsList = [];

  void saveContact() {
    Contacts newContact = Contacts(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
        prefered: selectedPreference ?? "N/A");
    setState(() {
      contactsList.add(newContact);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateContancts(contactsList);
    nameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    setState(() {
      selectedPreference = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    final l = AppLocalizations.of(context)!;
    preferences = [l.phoneText, l.email, l.whatsappText, l.naOption];

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
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(
            title: l.contactsBookTitle, icon: Icon(Icons.contact_page)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyBanner(
                  title: l.pleaseInsertDetails,
                  img: "Assets/images/agenda.png",
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l.name),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: l.phoneNumber),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: l.email),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedPreference,
                  items: preferences.map((preference) {
                    return DropdownMenuItem<String>(
                      value: preference,
                      child: Text(preference),
                    );
                  }).toList(),
                  hint: Text(l.selectPreferenceHint),
                  onChanged: (value) {
                    setState(() {
                      selectedPreference = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveContact,
                  child: Text(l.saveContactButtonText),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedContactsTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.contacts.length,
                        itemBuilder: (context, index) {
                          final contact = surveyData.contacts[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.name}: ${contact.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${l.phoneNumber}: ${contact.phoneNumber}'),
                                    Text('${l.email}: ${contact.email}'),
                                    Text(
                                        '${l.preferenceTitle}: ${contact.prefered}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
