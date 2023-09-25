import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';

class InfrastructureSurvey extends StatefulWidget {
  @override
  _InfrastructureSurveyState createState() => _InfrastructureSurveyState();
}

class _InfrastructureSurveyState extends State<InfrastructureSurvey>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context);

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
                    'Infrastructure Status:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.holiday_village_rounded)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Homes:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                'Total Demolished',
                surveyDataProvider.totalHomesDemolished,
                (value) => surveyDataProvider
                    .updateTotalHomesDemolished(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Unstable',
                surveyDataProvider.totalHomesUnstable,
                (value) => surveyDataProvider
                    .updateTotalHomesUnstable(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Intact',
                surveyDataProvider.totalHomesIntact,
                (value) => surveyDataProvider
                    .updateTotalHomesIntact(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Mosques:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                'Total Demolished',
                surveyDataProvider.totalMosquesDemolished,
                (value) => surveyDataProvider
                    .updateTotalMosquesDemolished(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Unstable',
                surveyDataProvider.totalMosquesUnstable,
                (value) => surveyDataProvider
                    .updateTotalMosquesUnstable(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Intact',
                surveyDataProvider.totalMosquesIntact,
                (value) => surveyDataProvider
                    .updateTotalMosquesIntact(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Schools:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                'Total Demolished',
                surveyDataProvider.totalSchoolsDemolished,
                (value) => surveyDataProvider
                    .updateTotalSchoolsDemolished(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Unstable',
                surveyDataProvider.totalSchoolsUnstable,
                (value) => surveyDataProvider
                    .updateTotalSchoolsUnstable(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Intact',
                surveyDataProvider.totalSchoolsIntact,
                (value) => surveyDataProvider
                    .updateTotalSchoolsIntact(int.tryParse(value) ?? 0),
              ),
              Text(
                'Stores:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                'Total Demolished',
                surveyDataProvider.totalStoresDemolished,
                (value) => surveyDataProvider
                    .updateTotalStoresDemolished(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Unstable',
                surveyDataProvider.totalStoresUnstable,
                (value) => surveyDataProvider
                    .updateTotalStoresUnstable(int.tryParse(value) ?? 0),
              ),
              buildInfrastructureInputFields(
                'Total Intact',
                surveyDataProvider.totalStoresIntact,
                (value) => surveyDataProvider
                    .updateTotalStoresIntact(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Roads:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                'Road Name',
                surveyDataProvider.roadName,
                (value) => surveyDataProvider.updateRoadName(value),
              ),
              DropdownButtonFormField<String>(
                value: surveyDataProvider.roadStatus,
                onChanged: (newValue) {
                  surveyDataProvider.updateRoadStatus(newValue ?? "");
                },
                items: <String>['Blocked', 'Demolished', 'Unstable', 'Stable']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 8.0),
              Text(
                'Vehicle Type:',
                style: TextStyle(fontSize: 16.0),
              ),
              DropdownButtonFormField<String>(
                value: surveyDataProvider.roadVehicleType,
                onChanged: (newValue) {
                  surveyDataProvider.updateRoadVehicleType(newValue ?? "");
                },
                items: <String>[
                  'Regular Car',
                  '4x4',
                  'Truck',
                  'Motorcycle',
                  'N/A'
                ].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Water & Electricity:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Water:',
                style: TextStyle(fontSize: 16.0),
              ),
              DropdownButtonFormField<String>(
                value: surveyDataProvider.waterStatus,
                onChanged: (newValue) {
                  surveyDataProvider.updateWaterStatus(newValue ?? "");
                },
                items: <String>['Available', 'Not Available']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 8.0),
              Text(
                'Electricity:',
                style: TextStyle(fontSize: 16.0),
              ),
              DropdownButtonFormField<String>(
                value: surveyDataProvider.electricityStatus,
                onChanged: (newValue) {
                  surveyDataProvider.updateElectricityStatus(newValue ?? "");
                },
                items: <String>['Available', 'Not Available']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfrastructureInputFields(
      String label, dynamic value, ValueChanged<String> onChanged) {
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
            keyboardType: TextInputType.text,
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
