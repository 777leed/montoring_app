// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/myTextField.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

// colors
  final mainColor = const Color(0xff0E773F);
  final mainTextColor = const Color.fromARGB(255, 1, 1, 8);
  final secondaryTextColor = const Color(0xff404040);
// textfield Controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();

// methods
  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Icon(Icons.handshake_rounded, size: 100)),
                        Text(
                          "Log In",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: mainTextColor, fontSize: 36),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MyTextField(
                            obs: false,
                            controller: emailController,
                            hint: "Email / ID"),
                        SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                            obs: true,
                            controller: passController,
                            hint: "Key / Password"),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            signUserIn();
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "If you've lost your credentials or wish to reset them, Please contact the admin",
                          style: TextStyle(
                              color: secondaryTextColor, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
