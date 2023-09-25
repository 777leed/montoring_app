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
  final nameController = TextEditingController();

  bool isLoading = false;

  Future<void> signUpUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
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
          builder: (context) => AuthPage(),
        ),
      );
    }
  }

  void goToSignInPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignInPage(),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mainTextColor, fontSize: 36),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                    obs: false,
                    controller: nameController,
                    hint: "Name",
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
                      : ElevatedButton(
                          onPressed: () {
                            signUpUser();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you already have an account, please ",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: goToSignInPage,
                        child: Text(
                          "log in",
                          style: TextStyle(
                            color: mainColor,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
