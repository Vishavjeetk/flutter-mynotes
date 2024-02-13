import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
          const Text("Your Email is not verified! Please Verify it by clicking link below"),
          TextButton(onPressed: () {
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
          }, child: const Text("Send Email to Verify!")),
          TextButton(onPressed: () async {
            await FirebaseAuth.instance.currentUser!.reload();
            if (context.mounted && FirebaseAuth.instance.currentUser!.emailVerified) {
              Navigator.pushNamedAndRemoveUntil(context, '/notes_view/', (route) => false);
            }
          }, child: const Text("Click here if you have verified your email"),)],
      ),
    );
  }
}