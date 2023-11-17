import 'package:flutter/material.dart';
import 'package:montoring_app/models/MyBuilding.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingSurvey extends StatefulWidget {
  @override
  _BuildingSurveyState createState() => _BuildingSurveyState();
}

class _BuildingSurveyState extends State<BuildingSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController buildingTypeController = TextEditingController();
  late String selectedCondition;
  late String selectedType;
  late List<String> buildingTypes;
  late List<String> buildingConditions;
  late String otherText;
  late String kinderText;
  late String unkText;
  late AppLocalizations l;

  List<MyBuilding> buildingList = [];

  void saveBuilding() {
    String newtype;
    if (selectedType == otherText) {
      newtype = buildingTypeController.text;
    } else {
      newtype = selectedType;
    }
    MyBuilding newBuilding =
        MyBuilding(buildingType: newtype, condition: selectedCondition);
    setState(() {
      buildingList.add(newBuilding);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateBuildings(buildingList);
    buildingTypeController.clear();
    setState(() {
      selectedCondition = unkText;
      selectedType = kinderText;
    });
  }

  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    selectedCondition = l.unknownText;
    selectedType = l.kindergartenText;
    unkText = l.unknownText;
    kinderText = l.kindergartenText;
    otherText = l.otherType;
    buildingTypes = [
      l.kindergartenText,
      l.schoolText,
      l.storeText,
      l.coOpText,
      l.associationText,
      l.clinicText,
      l.otherType
    ];
    buildingConditions = [
      l.unknownText,
      l.demolishedOption,
      l.unstableOption,
    ];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    buildingTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: myHeader(title: l.buildingSurveyTitle, icon: Icon(Icons.home)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyBanner(
                  title: l.pleaseInsertDetails,
                  img: "Assets/images/building.png",
                ),
                Text(
                  l.buildingType,
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButtonFormField(
                  value: selectedType.isNotEmpty ? selectedType : kinderText,
                  items: buildingTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value as String;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  l.condition,
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButtonFormField(
                  value: selectedCondition.isNotEmpty
                      ? selectedCondition
                      : unkText,
                  items: buildingConditions.map((condition) {
                    return DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value as String;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                if (selectedType == otherText) ...[
                  TextField(
                    controller: buildingTypeController,
                    decoration: InputDecoration(labelText: l.typeLabelText),
                  ),
                ],
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveBuilding,
                  child: Text(l.saveBuildingButtonText),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedBuildingsTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.buildings.length,
                        itemBuilder: (context, index) {
                          final building = surveyData.buildings[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.buildingType}: ${building.buildingType}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${l.buildingConditionTitle}: ${building.condition}',
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
