import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/firebase_options.dart';
import 'package:flutter_notes/login_screen.dart';
import 'package:flutter_notes/registration_screen.dart';
import 'package:flutter_notes/verify_email_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (FirebaseAuth.instance.currentUser == null) {
                return const RegistrationScreen();
              }
              else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                return const VerifyEmailView();
              }
            default:
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const LoginScreen();
        }
    );
  }
}






