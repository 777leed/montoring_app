import 'package:flutter/material.dart';
import 'package:montoring_app/components/dropdown.dart';
import 'package:montoring_app/styles.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';

class StatusSurvey extends StatefulWidget {
  StatusSurvey({super.key});

  @override
  State<StatusSurvey> createState() => _StatusSurveyState();
}

class _StatusSurveyState extends State<StatusSurvey>
    with AutomaticKeepAliveClientMixin {
  List<String> statusList = ['Unknown', 'Safe', 'Severe', 'Moderate', 'Minor'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Disaster Relief Monitoring & Evaluation Survey",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.mainTextColor),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Please fill in the information in this survey carefully to assess the current status of the area.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.secondaryTextColor),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Image.asset('Assets/images/analytic.png'),
                        ),
                        Text(
                          "What's The Current Status of The Area",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20),
                        CustomDropDown(
                          value: surveyDataProvider.selectedStatus,
                          itemsList: statusList,
                          onChanged: (value) {
                            surveyDataProvider.updateSelectedStatus(value);
                          },
                        ),
                        SizedBox(
                          height: 140,
                        )
                      ],
                    ),
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
