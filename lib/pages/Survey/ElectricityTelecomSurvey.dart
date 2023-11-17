import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ElectricityTelecomSurveyPage extends StatefulWidget {
  @override
  _ElectricityTelecomSurveyPageState createState() =>
      _ElectricityTelecomSurveyPageState();
}

class _ElectricityTelecomSurveyPageState
    extends State<ElectricityTelecomSurveyPage>
    with AutomaticKeepAliveClientMixin {
  bool isElectricityAvailable = true;
  String electricityNotAvailableReason = "";

  bool hasInternet = false;
  bool hasSatellites = false;
  bool hasMobileNetworkTowers = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: myHeader(
            title: l.electricityAndTelecommunicationText,
            icon: Icon(LineIcons.broadcastTower)),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MyBanner(
                  title: l.pleaseInsertDetails,
                  img: "Assets/images/tower.png",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.isElectricityAvailableQuestion,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Checkbox(
                    value: isElectricityAvailable,
                    onChanged: (value) {
                      setState(() {
                        isElectricityAvailable = value ?? false;
                        Provider.of<SurveyDataProvider>(context, listen: false)
                            .updateIsElectricityAvailable(
                                isElectricityAvailable);
                      });
                    },
                  ),
                ],
              ),
              if (!isElectricityAvailable) ...[
                TextFormField(
                  decoration:
                      InputDecoration(labelText: l.notAvailableReasonLabel),
                  onChanged: (value) {
                    setState(() {
                      electricityNotAvailableReason = value;
                      Provider.of<SurveyDataProvider>(context, listen: false)
                          .updateElectricityNotAvailableReason(
                              electricityNotAvailableReason);
                    });
                  },
                ),
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(l.hasInternetText),
                value: hasInternet,
                onChanged: (value) {
                  setState(() {
                    hasInternet = value ?? false;
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateHasInternet(hasInternet);
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(l.hasSatellitesText),
                value: hasSatellites,
                onChanged: (value) {
                  setState(() {
                    hasSatellites = value ?? false;
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateHasSatellites(hasSatellites);
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(l.hasMobileNetworkTowersText),
                value: hasMobileNetworkTowers,
                onChanged: (value) {
                  setState(() {
                    hasMobileNetworkTowers = value ?? false;
                    Provider.of<SurveyDataProvider>(context, listen: false)
                        .updateHasMobileNetworkTowers(hasMobileNetworkTowers);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
