import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyCrafts.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CraftsSurvey extends StatefulWidget {
  @override
  _CraftsSurveyState createState() => _CraftsSurveyState();
}

class _CraftsSurveyState extends State<CraftsSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController craftTypeController = TextEditingController();
  final TextEditingController menCountController = TextEditingController();
  final TextEditingController womenCountController = TextEditingController();

  List<MyCrafts> craftsList = [];

  void saveCraft() {
    MyCrafts newCraft = MyCrafts(
        typeOfCraft: craftTypeController.text,
        numberOfMen: int.tryParse(menCountController.text) ?? 0,
        numberOfWomen: int.tryParse(womenCountController.text) ?? 0);
    setState(() {
      craftsList.add(newCraft);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateCrafts(craftsList);
    craftTypeController.clear();
    menCountController.clear();
    womenCountController.clear();
  }

  @override
  void dispose() {
    craftTypeController.dispose();
    menCountController.dispose();
    womenCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:
            myHeader(title: l.craftsSurveyTitle, icon: Icon(Icons.color_lens)),
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
                  img: "Assets/images/handcraft.png",
                ),
                TextField(
                  controller: craftTypeController,
                  decoration: InputDecoration(labelText: l.craftTypeInputLabel),
                ),
                TextField(
                  controller: menCountController,
                  decoration: InputDecoration(labelText: l.numberOfMenTitle),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: womenCountController,
                  decoration: InputDecoration(labelText: l.numberOfWomenTitle),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveCraft,
                  child: Text(l.saveCraftButtonText),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedCraftsTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.crafts.length,
                        itemBuilder: (context, index) {
                          final craft = surveyData.crafts[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.craftTypeTitle}: ${craft.typeOfCraft}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${l.numberOfMen}: ${craft.numberOfMen}'),
                                    Text(
                                        '${l.numberOfWomen}: ${craft.numberOfWomen}'),
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
