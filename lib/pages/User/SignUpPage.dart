import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/myTextField.dart';
import 'package:montoring_app/pages/User/AuthPage.dart';
import 'package:montoring_app/pages/User/SignInPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final mainColor = const Color(0xff0E773F);
  final mainTextColor = const Color.fromARGB(255, 1, 1, 8);
  final secondaryTextColor = const Color(0xff404040);

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController(); // Add name controller

  bool isLoading = false;

  Future<void> signUpUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } catch (e) {
      print('Error signing up: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthPage(), // Replace with your sign-in page
        ),
      );
    }
  }

  void goToSignInPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignInPage(), // Replace with your sign-in page
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Image.asset('Assets/images/rc.png'),
                        ),
                      ),
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: mainTextColor, fontSize: 36),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyTextField(
                        obs: false,
                        controller: nameController, // Name field
                        hint: "Name", // Name hint
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        obs: false,
                        controller: emailController,
                        hint: "Email / ID",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        obs: true,
                        controller: passController,
                        hint: "Key / Password",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: () {
                                signUpUser();
                              },
                              child: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "If you already have an account, please ",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: goToSignInPage, // Navigate to sign-in page
                            child: Text(
                              "log in",
                              style: TextStyle(
                                color:
                                    mainColor, // You can use your main color here
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
