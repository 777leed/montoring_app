import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';

class PopulationSurvey extends StatefulWidget {
  @override
  _PopulationSurveyState createState() => _PopulationSurveyState();
}

class _PopulationSurveyState extends State<PopulationSurvey>
    with AutomaticKeepAliveClientMixin {
  int totalMenBefore = 0;
  int totalWomenBefore = 0;
  int totalBoysBefore = 0;
  int totalGirlsBefore = 0;

  int totalMenDeaths = 0;
  int totalWomenDeaths = 0;
  int totalBoysDeaths = 0;
  int totalGirlsDeaths = 0;

  int totalMenInjured = 0;
  int totalWomenInjured = 0;
  int totalBoysInjured = 0;
  int totalGirlsInjured = 0;

  int totalMenDisplaced = 0;
  int totalWomenDisplaced = 0;
  int totalBoysDisplaced = 0;
  int totalGirlsDisplaced = 0;

  int totalLivestockAnimals = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Population Status:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.people_alt)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Total Population Before the Earthquake:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                'Men',
                totalMenBefore,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMenBefore(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Women',
                totalWomenBefore,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomenBefore(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Boys',
                totalBoysBefore,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalBoysBefore(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Girls',
                totalGirlsBefore,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalGirlsBefore(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Deaths:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                'Men',
                totalMenDeaths,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMenDeaths(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Women',
                totalWomenDeaths,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomenDeaths(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Boys',
                totalBoysDeaths,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalBoysDeaths(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Girls',
                totalGirlsDeaths,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalGirlsDeaths(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Injured:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                'Men',
                totalMenInjured,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMenInjured(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Women',
                totalWomenInjured,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomenInjured(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Boys',
                totalBoysInjured,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalBoysInjured(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Girls',
                totalGirlsInjured,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalGirlsInjured(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Displaced:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                'Men',
                totalMenDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalMenDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Women',
                totalWomenDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalWomenDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Boys',
                totalBoysDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalBoysDisplaced(int.tryParse(value) ?? 0),
              ),
              buildPopulationInputFields(
                'Girls',
                totalGirlsDisplaced,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalGirlsDisplaced(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Livestock Animals:', // Added field label
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildPopulationInputFields(
                'Animals',
                totalLivestockAnimals,
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalLivestockAnimals(int.tryParse(value) ?? 0),
              ), // Added input field for livestock animals
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
              hintText: 'Enter $label',
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
