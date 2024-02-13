import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum PopUpMenuItems { logout, profile }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<PopUpMenuItems>(onSelected: (event) async {
            switch (event) {
              case PopUpMenuItems.logout:
                final shouldSignOutResult = await shouldSignOut(context);
                if (shouldSignOutResult && context.mounted) {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/login/', (route) => false);
                }
              case PopUpMenuItems.profile:
              // TODO: Handle this case.
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: PopUpMenuItems.logout,
                  child: Text(PopUpMenuItems.logout.name.toString()))
            ];
          })
        ],
      ),
    );
  }
}

Future<bool> shouldSignOut(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Are you Sure you want to Log out!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("No"))
          ],
        );
      }).then((value) => value ?? false);
}
