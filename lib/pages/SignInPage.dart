import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montoring_app/components/myTextField.dart';

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

  bool isLoading = false; // Track loading state

  Future<void> signUserIn() async {
    setState(() {
      isLoading = true; // Set loading state to true while signing in
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } catch (e) {
      // Handle sign-in errors
      print('Error signing in: $e');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading =
            false; // Set loading state to false when sign-in is complete
      });
    }
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
                          width: 150, // Adjust width as needed
                          height: 150, // Adjust height as needed
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
                      isLoading // Show loading indicator while loading
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
                      Text(
                        "If you've lost your credentials or wish to reset them, Please contact the admin",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
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
