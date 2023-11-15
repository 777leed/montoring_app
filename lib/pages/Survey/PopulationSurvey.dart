import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopulationSurvey extends StatefulWidget {
  @override
  _PopulationSurveyState createState() => _PopulationSurveyState();
}

class _PopulationSurveyState extends State<PopulationSurvey>
    with AutomaticKeepAliveClientMixin {
  int totalMen = 0;
  int totalWomen = 0;
  int totalOlderBoys = 0;
  int totalOlderGirls = 0;
  int totalYoungerBoys = 0;
  int totalYoungerGirls = 0;

  int totalFamilies = 0;

  int totalPopulation = 0;
  int totalHouseholds = 0;

  int totalMenDisplaced = 0;
  int totalWomenDisplaced = 0;
  int totalBoysDisplaced = 0;
  int totalGirlsDisplaced = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(
            title: l.populationSurveyTitle, icon: Icon(LineIcons.users)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MyBanner(title: "", img: "Assets/images/people.png"),
              ),
              Text(
                l.generalInfoTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                l.totalPopulationLabelText,
                totalPopulation,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalPopulation(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.totalFamiliesLabelText,
                totalFamilies,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalFamilies(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.totalHouseholdsText,
                totalHouseholds,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalHouseHolds(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                l.currentPopulationSectionTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                l.menLabelText,
                totalMen,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMen(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.womenLabelText,
                totalWomen,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomen(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.boysAbove18LabelText,
                totalOlderBoys,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalOlderBoys(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.boysUnder18LabelText,
                totalYoungerBoys,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalYoungerBoys(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.girlsAbove18LabelText,
                totalOlderGirls,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalOlderGirls(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.girlsUnder18LabelText,
                totalYoungerGirls,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalYoungerGirls(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                l.totalDisplacedTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                l.menLabelText,
                totalMenDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMenDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.womenLabelText,
                totalWomenDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomenDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.boysText,
                totalBoysDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalBoysDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                l.girlsText,
                totalGirlsDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalGirlsDisplaced(int.tryParse(value) ?? 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPopulationInputFields(
      String label, int value, ValueChanged<String> onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '$label',
            ),
            initialValue: value.toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
