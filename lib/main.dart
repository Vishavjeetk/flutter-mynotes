import 'package:flutter/material.dart';
import 'package:flutter_notes/registration_screen.dart';
import 'package:flutter_notes/verify_email_view.dart';

import 'home_page.dart';
import 'login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/login/': (context) {
          return const LoginScreen();
        },
        '/register/': (context) {
          return const RegistrationScreen();
        },
        '/verify_email/': (context) => const VerifyEmailView()
      },
    );
  }
}
