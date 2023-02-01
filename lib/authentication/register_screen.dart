import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

import '../main.dart';
import 'auth_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final focusName = FocusNode();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  bool isProcessing = false;

  // Crea totes les dades a ser mostrades en la pantalla d'enregistrament
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Desfocalitza quan es clica a fora del formulari
      onTap: () {
        focusName.unfocus();
        focusEmail.unfocus();
        focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Colors.blue[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Imatge del logotip
                Padding(
                    padding: const EdgeInsets.only(bottom:4),
                     child: ClipRect(child:
                    Image.asset('assets/chargetrip_logo.png', fit: BoxFit.fill,),
                    ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      // Camp per introduir el nom
                      TextFormField(
                        controller: nameTextController,
                        focusNode: focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Camp per introduir el email
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
                      const SizedBox(height: 16.0),
                      // Camp per introduir la contrasenya
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
                      const SizedBox(height: 16.0),
                      isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isProcessing = true;
                                });

                                if (formKey.currentState!.validate()) {
                                  User? user = await FireAuth
                                      .registerUsingEmailPassword(
                                    name: nameTextController.text,
                                    email: emailTextController.text,
                                    password: passwordTextController.text,
                                  );

                                  setState(() {
                                    isProcessing = false;
                                  });

                                  if (user != null) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(user: user),
                                      ),
                                      ModalRoute.withName('/'),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
                              child: const Text(
                                'Sign up',
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
          ),
        ),
      ),
    );
  }
}