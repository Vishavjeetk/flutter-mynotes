import 'package:flutter/material.dart';
import 'package:flutter_notes/services/auth/auth_service.dart';
import 'package:flutter_notes/utilities/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Here"),
      ),
      body: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: _email,
                    decoration: const InputDecoration(
                        hintText: "Enter email Id",
                        prefixIcon: Icon(Icons.email)),
                  ),
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    controller: _password,
                    decoration: const InputDecoration(
                        hintText: "Enter Password",
                        prefixIcon: Icon(Icons.password)),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase()
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          AuthService.firebase().sendEmailVerification();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("User Created Successfully")));
                            Navigator.pushNamed(context, verifyEmail);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      child: const Text("Register User")),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, loginScreen, (route) => false);
                      },
                      child: const Text(
                          "Already a registered user! Click here to Login."))
                ],
              ),
      );
  }
}
