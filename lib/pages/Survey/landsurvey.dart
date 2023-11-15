import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandsSurvey extends StatefulWidget {
  @override
  _LandsSurveyState createState() => _LandsSurveyState();
}

class _LandsSurveyState extends State<LandsSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController irrigatedLandsController =
      TextEditingController();
  final TextEditingController barrenLandsController = TextEditingController();
  final TextEditingController landsizeController = TextEditingController();

  bool subsistence = false;
  bool financial = false;
  bool belongsToubkal = false;

  @override
  void dispose() {
    irrigatedLandsController.dispose();
    barrenLandsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:
            myHeader(title: l.landsSurveyTitle, icon: Icon(LineIcons.landmark)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyBanner(
                title: l.pleaseInsertDetails,
                img: "Assets/images/homeland.png",
              ),
              TextField(
                controller: landsizeController,
                decoration: InputDecoration(labelText: l.landSizeLabel),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider
                      .updateLandSize(double.tryParse(value) ?? 0.0);
                },
              ),
              TextField(
                controller: irrigatedLandsController,
                decoration: InputDecoration(labelText: l.irrigatedLandsLabel),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider
                      .updateIrrigatedLands(double.tryParse(value) ?? 0.0);
                },
              ),
              TextField(
                controller: barrenLandsController,
                decoration: InputDecoration(labelText: l.barrenLandsLabel),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  SurveyDataProvider surveyDataProvider =
                      Provider.of<SurveyDataProvider>(context, listen: false);
                  surveyDataProvider
                      .updateBarrenLands(double.tryParse(value) ?? 0.0);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('Subsistence'),
                value: subsistence,
                onChanged: (value) {
                  setState(() {
                    subsistence = value ?? false;
                    SurveyDataProvider surveyDataProvider =
                        Provider.of<SurveyDataProvider>(context, listen: false);
                    surveyDataProvider.updateSubsistence(subsistence);
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(l.financialLabelText),
                value: financial,
                onChanged: (value) {
                  setState(() {
                    financial = value ?? false;
                    SurveyDataProvider surveyDataProvider =
                        Provider.of<SurveyDataProvider>(context, listen: false);
                    surveyDataProvider.updateFinancial(financial);
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(l.belongsToubkalLabelText),
                value: belongsToubkal,
                onChanged: (value) {
                  setState(() {
                    belongsToubkal = value ?? false;
                    SurveyDataProvider surveyDataProvider =
                        Provider.of<SurveyDataProvider>(context, listen: false);
                    surveyDataProvider.updateBelongsToubkal(belongsToubkal);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
