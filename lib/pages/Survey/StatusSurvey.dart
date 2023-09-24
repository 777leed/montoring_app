import 'package:flutter/material.dart';
import 'package:montoring_app/components/dropdown.dart';
import 'package:montoring_app/styles.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart'; // Import your SurveyDataProvider

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

    // Access the SurveyDataProvider
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context);

    return Scaffold(
      backgroundColor:
          Colors.blueGrey[100], // Adjust background color as needed
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Center the content vertically
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
                          width: 150, // Adjust the width of the image as needed
                          child: Image.asset('Assets/images/analytic.png'),
                        ),
                        Text(
                          "What's The Current Status of The Area",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20), // Add some spacing
                        CustomDropDown(
                          value: surveyDataProvider
                              .selectedStatus, // Use the value from the provider
                          itemsList: statusList,
                          onChanged: (value) {
                            // Update the value in the provider
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
