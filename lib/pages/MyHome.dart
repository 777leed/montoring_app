import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/pages/Unavailable/addNew.dart';
import 'package:montoring_app/pages/User/ProfilePage.dart';
import 'package:montoring_app/pages/syncPage.dart';
import 'package:montoring_app/styles.dart';
import 'dashboardPage.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GNav(
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            activeColor: CustomColors.mainColor,
            gap: 6,
            tabs: const [
              GButton(icon: LineIcons.home, text: "Home"),
              GButton(icon: LineIcons.plusCircle, text: "Add"),
              GButton(icon: LineIcons.user, text: "Profile"),
              GButton(icon: LineIcons.syncIcon, text: "Sync")
            ]),
        body: _pages[_selectedIndex]);
  }
}
