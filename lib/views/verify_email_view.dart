import 'package:flutter/material.dart';
import 'package:flutter_notes/services/auth/auth_service.dart';
import 'package:flutter_notes/utilities/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email"),),
      body: Column(
        children: [
          const Text("If you have verified email enter the next screen by clicking the link below"),
          TextButton(onPressed: () async {
            await AuthService.firebase().reload();
            if (context.mounted && AuthService.firebase().currentUser!.isEmailVerified) {
              Navigator.pushNamedAndRemoveUntil(context, notesView, (route) => false);
            }
          }, child: const Text("Click here if you have verified your email"),)],
      ),
    );
  }
}