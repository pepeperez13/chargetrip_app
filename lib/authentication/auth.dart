import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrem un nou user
  static Future<User?> registerUsingEmailPassword({
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User user = userCredential.user!;
      await user.updateDisplayName(name);
      return refreshUser(user);
    } on FirebaseAuthException catch (e) {
      // Gestionem les exceptions en cas que la contrasenya sigui massa facil o el email ja existeixi a la base de dades
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Per fer login amb un usuari ja registrat
  static Future<User?> signInUsingEmailPassword({
    String? email,
    String? password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    return null;
  }

  static Future<User?> refreshUser(User user) async {
    await user.reload();
    return _auth.currentUser;
  }
}




