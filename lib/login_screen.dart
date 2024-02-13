import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Column(
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
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: email, password: password);
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(
                                  "User LoggedIn Successfully")));
                          Navigator.pushNamedAndRemoveUntil(context, '/notes_view/', (route) => false);
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
                  Navigator.pushNamedAndRemoveUntil(context, '/register/', (route) => false);
                  }, child: const Text("New User! Register Here."))
              ],
            );
          default:
            return const Text("Loading.......");
        }
      },
      ),
    );
  }
}
