import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:montoring_app/pages/User/AuthPage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => SurveyDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xff0E773F);
    return MaterialApp(
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
