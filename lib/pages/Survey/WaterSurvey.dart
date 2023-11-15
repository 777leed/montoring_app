import 'package:flutter/material.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterSurveyPage extends StatefulWidget {
  @override
  _WaterSurveyPageState createState() => _WaterSurveyPageState();
}

class _WaterSurveyPageState extends State<WaterSurveyPage>
    with AutomaticKeepAliveClientMixin {
  bool hasRunningWater = false;
  bool hasWell = false;
  bool hasSinks = false;
  bool usesNaturalSources = false;
  bool isWaterAvailable = true;
  String notAvailableReason = "";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: myHeader(title: l.waterSurveyTitle, icon: Icon(Icons.water)),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: [
            MyBanner(
                title: l.waterSurveyQuestion, img: "Assets/images/hydro.png"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.isWaterAvailableQuestion,
                  style: TextStyle(fontSize: 16.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Checkbox(
                    value: isWaterAvailable,
                    onChanged: (value) {
                      setState(() {
                        isWaterAvailable = value ?? false;
                        SurveyDataProvider surveyDataProvider =
                            Provider.of<SurveyDataProvider>(context,
                                listen: false);
                        surveyDataProvider
                            .updateIsWaterAvailable(isWaterAvailable);
                      });
                    },
                  ),
                ),
              ],
            ),
            if (!isWaterAvailable) ...[
              TextFormField(
                decoration:
                    InputDecoration(labelText: l.notAvailableReasonLabel),
                onChanged: (value) {
                  setState(() {
                    notAvailableReason = value;
                    SurveyDataProvider surveyDataProvider =
                        Provider.of<SurveyDataProvider>(context, listen: false);
                    surveyDataProvider
                        .updateNotAvailableReason(notAvailableReason);
                  });
                },
              ),
            ],
            CheckboxListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(l.runningWaterLinkQuestion),
              value: hasRunningWater,
              onChanged: (value) {
                setState(() {
                  hasRunningWater = value ?? false;
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider.updateHasRunningWater(hasRunningWater);
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(l.runningWaterSourceQuestion),
              value: hasWell,
              onChanged: (value) {
                setState(() {
                  hasWell = value ?? false;
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider.updateHasWell(hasWell);
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(l.sinksInVillageQuestion),
              value: hasSinks,
              onChanged: (value) {
                setState(() {
                  hasSinks = value ?? false;
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider.updateHasSinks(hasSinks);
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(l.naturalWaterSourcesQuestion),
              value: usesNaturalSources,
              onChanged: (value) {
                setState(() {
                  usesNaturalSources = value ?? false;
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider
                      .updateUsesNaturalSources(usesNaturalSources);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
