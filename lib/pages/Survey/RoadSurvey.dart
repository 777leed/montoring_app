import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/models/MyRoads.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoadsSurveyPage extends StatefulWidget {
  @override
  _RoadsSurveyPageState createState() => _RoadsSurveyPageState();
}

class _RoadsSurveyPageState extends State<RoadsSurveyPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController roadNameController = TextEditingController();
  late String roadStatus;
  late String roadVehicleType;
  List<MyRoads> roadsList = [];
  late AppLocalizations l;

  void saveRoad() {
    MyRoads newRoad = MyRoads(
        roadName: roadNameController.text,
        roadStatus: roadStatus,
        vehicleType: roadVehicleType);
    setState(() {
      roadsList.add(newRoad);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateRoads(roadsList);
    roadNameController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    roadStatus = l.stableOption;
    roadVehicleType = l.naOption;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    roadNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: myHeader(title: l.roadsSurveyTitle, icon: Icon(LineIcons.road)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyBanner(
                    title: l.pleaseInsertDetails,
                    img: "Assets/images/road.png"),
                TextField(
                  controller: roadNameController,
                  decoration: InputDecoration(labelText: l.roadNameLabel),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: roadStatus,
                  onChanged: (newValue) {
                    setState(() {
                      roadStatus = newValue ?? l.stableOption;
                    });
                  },
                  items: <String>[
                    l.blockedOption,
                    l.demolishedOption,
                    l.unstableOption,
                    l.stableOption
                  ]
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: roadVehicleType,
                  onChanged: (newValue) {
                    setState(() {
                      roadVehicleType = newValue ?? l.naOption;
                    });
                  },
                  items: <String>[
                    l.regularCarOption,
                    l.fourByFourOption,
                    l.truckOption,
                    l.motorcycleOption,
                    l.muelOption,
                    l.byFootOption,
                    l.naOption
                  ]
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveRoad,
                  child: Text(l.saveRoadButton),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedRoadsTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: roadsList.length,
                    itemBuilder: (context, index) {
                      final road = roadsList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 200.0,
                          child: ListTile(
                            title: Text(
                              '${l.roadNameLabelText}: ${road.roadName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l.roadStatusLabelText}: ${road.roadStatus}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${l.vehicleTypeLabelText}: ${road.vehicleType}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
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
