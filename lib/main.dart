import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:montoring_app/pages/AuthPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
