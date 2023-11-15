import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/models/Infrastructure.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfrastructureSurvey extends StatefulWidget {
  @override
  _InfrastructureSurveyState createState() => _InfrastructureSurveyState();
}

class _InfrastructureSurveyState extends State<InfrastructureSurvey>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    Infrastructure infrastructure =
        Provider.of<SurveyDataProvider>(context).infrastructure;

    return Scaffold(
      appBar: AppBar(
        title:
            myHeader(title: l.infraSurveyTitle, icon: Icon(LineIcons.building)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MyBanner(
                    title: l.pleaseInsertDetails,
                    img: "Assets/images/house.png"),
              ),
              Text(
                l.homesLabel,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              buildInfrastructureInputFields(
                l.totalHomesText,
                infrastructure.totalHomes.toString(),
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updatetotalHomes(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              buildInfrastructureInputFields(
                l.unsafeHomesLabel,
                infrastructure.totalHomesUnstable.toString(),
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalHomesUnstable(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
              buildInfrastructureInputFields(
                l.remainingHomesLabel,
                infrastructure.totalHomesIntact.toString(),
                (value) =>
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateTotalHomesIntact(int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfrastructureInputFields(
      String label, String value, ValueChanged<String> onChanged) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: '$label', labelText: '$label'),
      initialValue: value,
      onChanged: onChanged,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
