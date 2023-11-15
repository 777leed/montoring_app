import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationSurvey extends StatefulWidget {
  @override
  _EducationSurveyState createState() => _EducationSurveyState();
}

class _EducationSurveyState extends State<EducationSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController literateMenController = TextEditingController();
  final TextEditingController literateWomenController = TextEditingController();
  final TextEditingController postGraduateMenController =
      TextEditingController();
  final TextEditingController postGraduateWomenController =
      TextEditingController();
  final TextEditingController baccalaureateMenController =
      TextEditingController();
  final TextEditingController baccalaureateWomenController =
      TextEditingController();
  final TextEditingController middleSchoolGraduateMenController =
      TextEditingController();
  final TextEditingController middleSchoolGraduateWomenController =
      TextEditingController();
  final TextEditingController primarySchoolGraduateMenController =
      TextEditingController();
  final TextEditingController primarySchoolGraduateWomenController =
      TextEditingController();
  final TextEditingController illiterateMenController = TextEditingController();
  final TextEditingController illiterateWomenController =
      TextEditingController();
  bool hasSchool = false;

  Widget titleMaker(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      ValueChanged<String> onChanged) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(
            title: l.educationSurveyText, icon: Icon(LineIcons.school)),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyBanner(
                    title: l.pleaseInsertDetails,
                    img: "Assets/images/graduation.png"),
                SizedBox(
                  height: 10,
                ),
                titleMaker(l.literate),
                buildTextField(
                    l.numberOfMen,
                    literateMenController,
                    (value) => Provider.of<SurveyDataProvider>(context,
                            listen: false)
                        .updateNumberOfLiterateMen(int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    literateWomenController,
                    (value) => Provider.of<SurveyDataProvider>(context,
                            listen: false)
                        .updateNumberOfLiterateWomen(int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 20,
                ),
                titleMaker(l.postGraduate),
                buildTextField(
                    l.numberOfMen,
                    postGraduateMenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfPostGraduateMen(
                                int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    postGraduateWomenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfPostGraduateWomen(
                                int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 20,
                ),
                titleMaker(l.baccalaureate),
                buildTextField(
                    l.numberOfMen,
                    baccalaureateMenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfBaccalaureateMen(
                                int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    baccalaureateWomenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfBaccalaureateWomen(
                                int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 20,
                ),
                titleMaker(l.middleSchool),
                buildTextField(
                    l.numberOfMen,
                    middleSchoolGraduateMenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfMiddleSchoolGraduateMen(
                                int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    middleSchoolGraduateWomenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfMiddleSchoolGraduateWomen(
                                int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 20,
                ),
                titleMaker(l.primarySchool),
                buildTextField(
                    l.numberOfMen,
                    primarySchoolGraduateMenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfPrimarySchoolGraduateMen(
                                int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    primarySchoolGraduateWomenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfPrimarySchoolGraduateWomen(
                                int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 20,
                ),
                titleMaker(l.illiterate),
                buildTextField(
                    l.numberOfMen,
                    illiterateMenController,
                    (value) => Provider.of<SurveyDataProvider>(context,
                            listen: false)
                        .updateNumberOfIlliterateMen(int.tryParse(value) ?? 0)),
                buildTextField(
                    l.numberOfWomen,
                    illiterateWomenController,
                    (value) =>
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateNumberOfIlliterateWomen(
                                int.tryParse(value) ?? 0)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        l.primarySchoolOrKindergartenQuestion,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Checkbox(
                      value: hasSchool,
                      onChanged: (value) {
                        setState(() {
                          hasSchool = value ?? false;
                          Provider.of<SurveyDataProvider>(context,
                                  listen: false)
                              .updateHasSchool(hasSchool);
                        });
                      },
                    ),
                  ],
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
