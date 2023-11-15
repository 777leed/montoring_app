import 'package:flutter/material.dart';
import 'package:montoring_app/components/myCard.dart';
import 'package:montoring_app/components/myTitle.dart';
import 'package:montoring_app/pages/Navigation/wherePage.dart';
import 'package:montoring_app/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class onlyDisaster extends StatefulWidget {
  onlyDisaster({super.key});

  @override
  State<onlyDisaster> createState() => _onlyDisasterState();
}

class _onlyDisasterState extends State<onlyDisaster> {
  late AppLocalizations l;
  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        myTitle(
            title: l.disasterReliefTitle, icon: Icon(Icons.warning_rounded)),
        SizedBox(
          height: 10,
        ),
        myCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WherePage(),
                ),
              );
            },
            img: 'Assets/images/earthquake.png',
            color: CustomColors.secondaryColor,
            title: l.moroccoEarthquakeTitle,
            desc: l.disasterRecoveryDescription),
      ],
    );
  }
}
