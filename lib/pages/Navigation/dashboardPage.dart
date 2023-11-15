import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Subpages/all.dart';
import 'package:montoring_app/pages/Subpages/disaster.dart';
import 'package:montoring_app/pages/Subpages/projects.dart';
import 'package:montoring_app/pages/Subpages/workshops.dart';
import 'package:montoring_app/styles.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:montoring_app/utils/ChangeLanguageNotifier.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class dashboard extends StatefulWidget {
  dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  void didChangeDependencies() {
    items = [
      AppLocalizations.of(context)!.allText,
      AppLocalizations.of(context)!.disasterText,
      AppLocalizations.of(context)!.projectsText,
      AppLocalizations.of(context)!.workshopsText
    ];
    super.didChangeDependencies();
  }

  void getPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        setState(() {});
      }
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  List<IconData> icons = [
    Icons.clear_all_rounded,
    Icons.warning_rounded,
    Icons.flag_rounded,
    Icons.track_changes_outlined,
  ];
  int current = 0;

  List<Widget> myTabs = [
    allCategories(),
    onlyDisaster(),
    onlyProjects(),
    onlyWorkshops()
  ];

  Widget renderTabBar() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(5),
                    width: 80,
                    height: 45,
                    decoration: BoxDecoration(
                      color: current == index ? Colors.white70 : Colors.white54,
                      borderRadius: current == index
                          ? BorderRadius.circular(15)
                          : BorderRadius.circular(10),
                      border: current == index
                          ? Border.all(color: CustomColors.mainColor, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        items[index],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: current == index,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                          color: CustomColors.mainColor,
                          shape: BoxShape.circle),
                    ))
              ],
            );
          }),
    );
  }

  Widget renderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.dashboardText,
              style: TextStyle(color: CustomColors.secondaryTextColor),
            ),
            Container(
              width: 200,
              child: Text(
                user.email!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: CustomColors.mainTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.language,
            color: CustomColors.mainTextColor,
          ),
          onPressed: () {
            final provider =
                Provider.of<ChangeLanguage>(context, listen: false);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      Text(AppLocalizations.of(context)!.selectPreferenceHint),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            provider.changeLocale(Locale('en'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Arabic'),
                          onTap: () {
                            provider.changeLocale(Locale('ar'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('French'),
                          onTap: () {
                            provider.changeLocale(Locale('fr'));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              ClipPath(
                clipper: WaveClipperOne(flip: true),
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.secondaryLighterColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        renderHeader(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcomeAboardText,
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    renderTabBar(),
                    myTabs[current],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
