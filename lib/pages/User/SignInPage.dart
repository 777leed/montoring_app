import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/myTextField.dart';
import 'package:montoring_app/pages/User/SignUpPage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final mainColor = const Color(0xff0E773F);
  final mainTextColor = const Color.fromARGB(255, 1, 1, 8);
  final secondaryTextColor = const Color(0xff404040);

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;

  Future<void> signUserIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } catch (e) {
      print('Error signing in: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to navigate to the sign-up page
  void goToSignUpPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignUpPage(), // Replace with your sign-up page
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
                            "If you don't have an account, ",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                goToSignUpPage, // Navigate to sign-up page
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color:
                                    mainColor, // You can use your main color here
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
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
