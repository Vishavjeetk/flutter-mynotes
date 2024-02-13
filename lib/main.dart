import 'package:flutter/material.dart';
import 'package:flutter_notes/registration_screen.dart';
import 'package:flutter_notes/verify_email_view.dart';

import 'home_page.dart';
import 'login_screen.dart';
import 'notes_view.dart';

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
        '/login/': (context) {
          return const LoginScreen();
        },
        '/register/': (context) {
          return const RegistrationScreen();
        },
        '/verify_email/': (context) => const VerifyEmailView(),
        '/notes_view/': (context) => const NotesView()
      },
    );
  }
}
