import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyHerbs.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HerbsSurvey extends StatefulWidget {
  @override
  _HerbsSurveyState createState() => _HerbsSurveyState();
}

class _HerbsSurveyState extends State<HerbsSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController herbsController = TextEditingController();

  List<Myherbs> herbsList = [];

  void saveHerb() {
    Myherbs newHerb = Myherbs(name: herbsController.text);
    setState(() {
      herbsList.add(newHerb);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateHerbs(herbsList);
    herbsController.clear();
  }

  @override
  void dispose() {
    herbsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(title: l.herbsSurveyTitle, icon: Icon(Icons.eco)),
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
                  img: "Assets/images/thyme.png",
                ),
                TextField(
                  controller: herbsController,
                  decoration: InputDecoration(labelText: l.herbNameInputLabel),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveHerb,
                  child: Text(l.saveHerbButton),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedHerbsText,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.herbs.length,
                        itemBuilder: (context, index) {
                          final herb = surveyData.herbs[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.herbNameLabelText}: ${herb.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
