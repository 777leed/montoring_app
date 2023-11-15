import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/pages/Unavailable/SyncPage.dart';
import 'package:montoring_app/pages/Unavailable/addNew.dart';
import 'package:montoring_app/pages/User/ProfilePage.dart';
import 'package:montoring_app/styles.dart';
import 'dashboardPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Widget> _pages = [
    dashboard(),
    addNew(),
    MyProfile(),
    SyncPage(),
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: CustomColors.secondaryLighterColor,
      ),
      child: Scaffold(
          bottomNavigationBar: GNav(
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.white,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              activeColor: CustomColors.mainColor,
              gap: 6,
              tabs: [
                GButton(
                    icon: LineIcons.home,
                    text: AppLocalizations.of(context)!.home),
                GButton(
                    icon: LineIcons.plusCircle,
                    text: AppLocalizations.of(context)!.add),
                GButton(
                    icon: LineIcons.user,
                    text: AppLocalizations.of(context)!.profileText),
                GButton(
                    icon: LineIcons.syncIcon,
                    text: AppLocalizations.of(context)!.syncText)
              ]),
          body: _pages[_selectedIndex]),
    );
  }
}
