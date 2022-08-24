import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/screens/onboarding/welcome_screen.dart';
import 'package:med_connect/screens/auth/auth_screen.dart';
import 'package:med_connect/screens/home/tab_view.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class AuthService {
  FirestoreService db = FirestoreService();
  FirebaseAuth instance = FirebaseAuth.instance;

  User? get currentUser => instance.currentUser;
  String get uid => currentUser!.uid;

  void signUp(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context, message: 'Creating account...');

    instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(ktimeout)
        .then((value) {
      authFuction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          showAlertDialog(context,
              message: 'The password provided is too weak.');
        } else if (error.code == 'email-already-in-use') {
          showAlertDialog(context,
              message: 'The account already exists for that email.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context);

    instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(ktimeout)
        .then((value) {
      authFuction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          showAlertDialog(context, message: 'No user found for that email.');
        } else if (error.code == 'wrong-password') {
          showAlertDialog(context,
              message: 'Wrong password provided for that user.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  void signOut(BuildContext context) async {
    showLoadingDialog(context, message: 'Signing out...');

    instance.signOut().timeout(ktimeout).then((value) {
      authFuction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Error signing out');
    });
  }

  authFuction(BuildContext context) {
    if (currentUser != null) {
      db.patientDocument.get().timeout(ktimeout).then((value) {
        if (value.data() == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TabView()),
              (route) => false);
        }
      }).onError((error, stackTrace) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ErrorScreen()),
            (route) => false);
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthScreen(authType: AuthType.login)),
          (route) => false);
    }
  }
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key}) : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Error fetching info'),
            TextButton(
              onPressed: () {
                showLoadingDialog(context);
                auth.authFuction(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
