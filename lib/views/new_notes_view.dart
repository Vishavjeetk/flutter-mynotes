import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/auth/auth_user.dart';
import 'package:flutter_notes/services/auth/auth_service.dart';

import '../services/crud/notes_service.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {

  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textEditingController;

  Future<DatabaseNote> createNote() async {
    final currentNote = _note;
    if (currentNote != null) {
      return Future.value(currentNote);
    }
    final userEmail = AuthService.firebase().currentUser!;
    final owner = await _noteService.getUser(email: userEmail.email!);
    final createdNote = await _noteService.createNote(owner: owner);
    _note = createdNote;
    return createdNote;
  }

  Future<void> deleteNoteIfTextFieldIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      await _noteService.deleteNote(id: note.id);
    }
  }

  Future<void> saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if(_textEditingController.text.isNotEmpty && note != null) {
      await _noteService.updateNote(note: note, text: _textEditingController.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noteService = NoteService();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    saveNoteIfTextIsNotEmpty();
    deleteNoteIfTextFieldIsEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
      ),
      body: FutureBuilder(
        future: createNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Enter your New note here...."
                ),
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
