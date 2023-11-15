import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montoring_app/components/myTextField.dart';
import 'package:montoring_app/pages/User/AuthPage.dart';
import 'package:montoring_app/pages/User/SignInPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:montoring_app/utils/ChangeLanguageNotifier.dart';
import 'package:provider/provider.dart';

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
      debugPrint('Error signing up: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error)),
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
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          final provider = Provider.of<ChangeLanguage>(context, listen: false);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.selectPreferenceHint),
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
        child: Icon(Icons.language),
      ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    l.signUpButton,
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        color: mainTextColor),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                    obs: false,
                    controller: nameController,
                    hint: l.nameTextField,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    obs: false,
                    controller: emailController,
                    hint: l.emailTextField,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    obs: true,
                    controller: passController,
                    hint: l.passwordTextField,
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
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          child: Text(
                            l.signUpButton,
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.displayLarge,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.logInText,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: goToSignInPage,
                        child: Text(
                          ' ' + l.logInButton,
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
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
