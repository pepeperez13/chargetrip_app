import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'auth_validator.dart';
import 'register_screen.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  // Controllers per als camps de text editables
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  bool isProcessing = false;

  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // Crea la organització de la pantalla del login
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusEmail.unfocus();
        focusPassword.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: ClipRect(child:
                      Image.asset('assets/chargetrip_logo.png', fit: BoxFit.fill,),
                      )
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          // Camp de text per introduir el e-mail
                          TextFormField(
                            controller: emailTextController,
                            focusNode: focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Camp de text per introduir la contrasenya
                          TextFormField(
                            controller: passwordTextController,
                            focusNode: focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          isProcessing
                              ? const CircularProgressIndicator()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  // Segons les dades introduides, realitza un procés de verificació o un altre
                                  onPressed: () async {
                                    focusEmail.unfocus();
                                    focusPassword.unfocus();

                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        isProcessing = true;
                                      });

                                      User? user = await FireAuth
                                          .signInUsingEmailPassword(
                                        email: emailTextController.text,
                                        password:
                                        passwordTextController.text,
                                      );

                                      setState(() {
                                        isProcessing = false;
                                      });

                                      if (user != null) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(user: user),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom( backgroundColor: Colors.blue[800]),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24.0),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom( backgroundColor: Colors.blue[800]),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}