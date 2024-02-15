import 'package:flutter/material.dart';
import 'package:flutter_notes/auth/auth_service.dart';
import 'package:flutter_notes/utilities/routes.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter App"),
      ),
      body: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: _email,
                  decoration: const InputDecoration(hintText: "Enter email Id",
                      prefixIcon: Icon(Icons.email)),
                ),
                TextField(
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(hintText: "Enter Password",
                      prefixIcon: Icon(Icons.password)),
                ),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().signInWithEmailAndPassword(email: email, password: password,);
                        if (context.mounted && !AuthService.firebase().currentUser!.isEmailVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(
                                  "Verify Email First")));
                        }
                        if(context.mounted && AuthService.firebase().currentUser!.isEmailVerified){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(
                                  "User LoggedIn Successfully")));
                          Navigator.of(context).pushNamedAndRemoveUntil(notesView, (route) => false);
                        }
                      }
                      catch (e) {
                        if(context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));}
                      }
                    },
                    child: const Text("Login")),
                const SizedBox(height: 20,),
                TextButton(onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, registerScreen, (route) => false);
                  }, child: const Text("New User! Register Here."))
              ],
            ),
    );
  }
}
