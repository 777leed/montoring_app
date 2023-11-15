import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:montoring_app/l10n/l10n.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:montoring_app/pages/User/AuthPage.dart';
import 'package:montoring_app/utils/ChangeLanguageNotifier.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final changeLanguage = ChangeLanguage();
  await changeLanguage.loadLanguage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SurveyDataProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ChangeLanguage()),
        // Add other providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xff0E773F);
    final changeLanguage = Provider.of<ChangeLanguage>(context);

    return MaterialApp(
      supportedLocales: L10n.all,
      locale: changeLanguage.currentLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Resilient Communites',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: AuthPage(),
    );
  }
}
