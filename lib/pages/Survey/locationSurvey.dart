import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationSurveyPage extends StatefulWidget {
  @override
  _LocationSurveyPageState createState() => _LocationSurveyPageState();
}

class _LocationSurveyPageState extends State<LocationSurveyPage>
    with AutomaticKeepAliveClientMixin {
  String village = '';
  String valley = '';
  String commune = '';
  String province = '';
  String? villageError;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            myHeader(title: l.locationSurveyTitle, icon: Icon(LineIcons.city)),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: MyBanner(
                title: l.pleaseInsertDetails,
                img: "Assets/images/village.png",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: l.villageLabel,
                errorText: villageError,
              ),
              onChanged: (value) {
                setState(() {
                  village = value;
                  if (village.isEmpty) {
                    villageError = l.villageLabel;
                  } else {
                    villageError = null;
                  }
                  Provider.of<SurveyDataProvider>(context, listen: false)
                      .updateVillage(village);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: l.valleyLabel),
              onChanged: (value) {
                setState(() {
                  valley = value;
                  Provider.of<SurveyDataProvider>(context, listen: false)
                      .updateValley(valley);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: l.communeLabel),
              onChanged: (value) {
                setState(() {
                  commune = value;
                  Provider.of<SurveyDataProvider>(context, listen: false)
                      .updateCommune(commune);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: l.provinceLabel),
              onChanged: (value) {
                setState(() {
                  province = value;
                  Provider.of<SurveyDataProvider>(context, listen: false)
                      .updateProvince(province);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
