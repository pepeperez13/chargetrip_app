import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authentication/auth.dart';
import 'authentication/login_screen.dart';

class AccountSettings extends StatefulWidget {
  final User? user;

  const AccountSettings({required this.user});

  @override
  State<AccountSettings> createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  User? _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  // Pantalla que mostra la informació del perfil concret de l'usuari
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Center(
              child: Text('Your profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            const SizedBox(height: 80),
            // Mostrem el nom del usuari i si el seu e-mail ha estat verificat o no
            Text(
              'NAME: ${_currentUser?.displayName}',
              style: const TextStyle(fontSize: 22,  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser?.email}',
              style: TextStyle(fontSize: 22,  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32.0),
            _currentUser!.emailVerified
                ? Text(
              'Email verified',
              style: TextStyle(fontSize: 22).copyWith(color: Colors.green),
            )
                : Text(
              'Email not verified',
              style: TextStyle(fontSize: 22).copyWith(color: Colors.red),
            ),
            const SizedBox(height: 16.0),
            _isSendingVerification
                ? const CircularProgressIndicator()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child:
                    Padding(
                      padding: EdgeInsets.all(22),
                      child:
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                            _isSendingVerification = true;
                          });
                          await _currentUser?.sendEmailVerification();
                          setState(() {
                            _isSendingVerification = false;
                          });
                          },
                        child: const Text('Verify email'),
                          style: ElevatedButton.styleFrom( backgroundColor: Colors.blue[800]),
                        ),
                    ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(_currentUser!);

                    if (user != null) {
                      setState(() {
                        _currentUser = user;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _isSigningOut
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}