import 'package:flutter/material.dart';
import 'package:flutter_notes/views/registration_screen.dart';
import 'package:flutter_notes/utilities/routes.dart';
import 'package:flutter_notes/views/verify_email_view.dart';
import 'home_page.dart';
import 'views/login_screen.dart';
import 'views/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        loginScreen: (context) {
          return const LoginScreen();
        },
        registerScreen: (context) {
          return const RegistrationScreen();
        },
        verifyEmail: (context) => const VerifyEmailView(),
        notesView: (context) => const NotesView()
      },
    );
  }
}
