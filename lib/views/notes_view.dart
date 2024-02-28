import 'package:flutter/material.dart';
import 'package:flutter_notes/services/auth/auth_service.dart';
import 'package:flutter_notes/services/crud/notes_service.dart';
import 'package:flutter_notes/utilities/routes.dart';

import '../enums/menu_actions.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  final userEmail = AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushNamed(context, newNotesView);
          }, icon: const Icon(Icons.add)),
          PopupMenuButton<PopUpMenuItems>(onSelected: (event) async {
            switch (event) {
              case PopUpMenuItems.logout:
                final shouldSignOutResult = await shouldSignOut(context);
                if (shouldSignOutResult && context.mounted) {
                  AuthService.firebase().logOut();
                  Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
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
      body: FutureBuilder(
        future: _noteService.getAllNotes(),
        builder: (context,snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(stream: _noteService.allNotes, builder: (context,snapshot) {
                switch (snapshot.connectionState) {

                  case ConnectionState.waiting:
                    // TODO: Handle this case.

                  default:
                    return const Text("Loading");
                }
              });

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
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
