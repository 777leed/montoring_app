import 'package:flutter/material.dart';
import 'package:montoring_app/models/IrrigationSystem.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IrrigationSurvey extends StatefulWidget {
  @override
  _IrrigationSurveyState createState() => _IrrigationSurveyState();
}

class _IrrigationSurveyState extends State<IrrigationSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController timingController = TextEditingController();

  void saveIrrigationSystem(List<IrrigationSystem> irrigationSystemsList) {
    IrrigationSystem newIrrigationSystem = IrrigationSystem(
        name: nameController.text,
        purpose: purposeController.text,
        timing: timingController.text);
    setState(() {
      irrigationSystemsList.add(newIrrigationSystem);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateIrrigationSystems(irrigationSystemsList);
  }

  @override
  void dispose() {
    nameController.dispose();
    purposeController.dispose();
    timingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:
            myHeader(title: l.irrigationSurveyTitle, icon: Icon(Icons.water)),
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
                  img: "Assets/images/sprinkler.png",
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l.nameInputLabel),
                ),
                TextField(
                  controller: purposeController,
                  decoration: InputDecoration(labelText: l.purposeLabel),
                ),
                TextField(
                  controller: timingController,
                  decoration: InputDecoration(labelText: l.timingLabel),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    SurveyDataProvider surveyDataProvider =
                        Provider.of<SurveyDataProvider>(context, listen: false);
                    saveIrrigationSystem(surveyDataProvider.irrigationSystems);
                    nameController.clear();
                    purposeController.clear();
                    timingController.clear();
                  },
                  child: Text(l.saveButtonLabel),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedSystemsLabel,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.irrigationSystems.length,
                        itemBuilder: (context, index) {
                          final irrigationSystem =
                              surveyData.irrigationSystems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.nameInputLabel}": ${irrigationSystem.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${l.purposeLabel}": ${irrigationSystem.purpose}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${l.timingLabelText}": ${irrigationSystem.timing}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
