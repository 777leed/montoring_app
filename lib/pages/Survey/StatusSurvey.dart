import 'package:flutter/material.dart';
import 'package:montoring_app/components/dropdown.dart';
import 'package:montoring_app/pages/Maps/HelperMe.dart';
import 'package:montoring_app/styles.dart';
import 'package:provider/provider.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusSurvey extends StatefulWidget {
  StatusSurvey({super.key});

  @override
  State<StatusSurvey> createState() => _StatusSurveyState();
}

class _StatusSurveyState extends State<StatusSurvey>
    with AutomaticKeepAliveClientMixin {
  late List<String> statusList;

  @override
  void didChangeDependencies() {
    final l = AppLocalizations.of(context)!;
    statusList = [l.unknownText, l.lowText, l.mediumText, l.highText];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

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
                  l.disasterReliefText,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.mainTextColor),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  l.pleaseFill,
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
                          l.currentNeedsStatusQuestion,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20),
                        CustomDropDown(
                          value: HelperMe().localTransNotNull(
                              surveyDataProvider.selectedStatus, l),
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
