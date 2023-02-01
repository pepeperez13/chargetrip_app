import 'package:firebase_auth/firebase_auth.dart';
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
  User? currentUser;

  @override
  void initState() {
    currentUser = widget.user;
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
              'NAME: ${currentUser?.displayName}',
              style: const TextStyle(fontSize: 22,  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${currentUser?.email}',
              style: const TextStyle(fontSize: 22,  fontStyle: FontStyle.italic),
            ),
            // En funcio de si el mail s'ha verificat es mostra un missatge o un altre
            const SizedBox(height: 32.0),
            currentUser!.emailVerified
                ? Text(
              'Email verified',
              style: const TextStyle(fontSize: 22).copyWith(color: Colors.green),
            )
                : Text(
              'Email not verified',
              style: const TextStyle(fontSize: 22).copyWith(color: Colors.red),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child:
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: ElevatedButton(
                      onPressed: () async {
                        await currentUser?.sendEmailVerification();
                        },
                      style: ElevatedButton.styleFrom( backgroundColor: Colors.blue[800]),
                      child: const Text('Verify email'),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(currentUser!);
                    if (user != null) {
                      setState(() {
                        currentUser = user;
                      });
                    }
                  },
                ),
              ],
            ),
            // Definim un botó que ens permet tancar sessió
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Esperem a que Firebase tanqui sessió
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Anem a pagina de login
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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