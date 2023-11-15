import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/models/LiveStock.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LivestockSurvey extends StatefulWidget {
  @override
  _LivestockSurveyState createState() => _LivestockSurveyState();
}

class _LivestockSurveyState extends State<LivestockSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController livestockNameController = TextEditingController();
  final TextEditingController livestockNumberController =
      TextEditingController();

  List<Livestock> livestockList = [];

  void saveLivestock() {
    Livestock newLivestock = Livestock(
        name: livestockNameController.text,
        number: int.tryParse(livestockNumberController.text) ?? 0);
    setState(() {
      livestockList.add(newLivestock);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateLivestock(livestockList);
    livestockNameController.clear();
    livestockNumberController.clear();
  }

  @override
  void dispose() {
    livestockNameController.dispose();
    livestockNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(
            title: l.livestockPageTitle, icon: Icon(LineIcons.campground)),
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
                  img: "Assets/images/farm.png",
                ),
                TextField(
                  controller: livestockNameController,
                  decoration: InputDecoration(labelText: l.livestockNameLabel),
                ),
                TextField(
                  controller: livestockNumberController,
                  decoration:
                      InputDecoration(labelText: l.livestockNumberLabel),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveLivestock,
                  child: Text(l.saveLivestockButton),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedLivestockTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: livestockList.length,
                    itemBuilder: (context, index) {
                      final livestock = livestockList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 200.0,
                          child: ListTile(
                            title: Text(
                              '${l.livestockNameLabel}: ${livestock.name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${l.livestockNumberLabel} ${livestock.number}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                )
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
