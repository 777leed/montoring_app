import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Navigation/MyHome.dart';
import 'package:montoring_app/pages/User/SignInPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyHome();
            } else {
              return SignInPage();
            }
          }),
    );
  }
}
