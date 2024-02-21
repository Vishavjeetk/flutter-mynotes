import 'package:flutter/material.dart';
import 'package:flutter_notes/services/auth/auth_service.dart';
import 'package:flutter_notes/views/login_screen.dart';
import 'package:flutter_notes/views/notes_view.dart';
import 'package:flutter_notes/views/registration_screen.dart';
import 'package:flutter_notes/views/verify_email_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (AuthService.firebase().currentUser == null) {
                return const RegistrationScreen();
              }
              else if (AuthService.firebase().currentUser!.isEmailVerified) {
                return const VerifyEmailView();
              }
              else if (AuthService.firebase().currentUser!.isEmailVerified) {
                return const NotesView();
              }
            default:
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const LoginScreen();
        }
    );
  }
}






