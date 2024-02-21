import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'crud_exceptions.dart';

class NoteService {
  sqflite.Database? _db;

  Future<DatabaseNote> updateNote ({required DatabaseNote note, required String text,}) async {
    final db = _getDatabaseOrThrowException();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      titleCol: text,
      isSyncedWithCloudCol: false,
    }, where: "id = ?", whereArgs: [note.id]);
    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    }
    return await getNote(id: note.id);
  }
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrowException();
    final result = await db.query(noteTable);
    return result.map((e) => DatabaseNote.fromRow(e));
  }
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrowException();
    final note = await db.query(noteTable, where: "id = ?", whereArgs: [id]);
    if (note.isEmpty) {
      throw CouldNotFindNoteException();
    }
    return DatabaseNote.fromRow(note.first);
  }
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrowException();
    return await db.delete(noteTable);
  }
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrowException();
    final deletedCount = await db.delete(noteTable, where: "id = ?", whereArgs: [id]);
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    }
  }
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrowException();
    final user = await getUser(email: owner.email.toLowerCase());
    if (user != owner) {
      throw UserDoesNotExistException();
    }
    const text = '';
    final newNoteId = await db.insert(noteTable, {
      userIdCol: owner.id,
      titleCol: text,
      isSyncedWithCloudCol: true
    });
    return DatabaseNote(id: newNoteId, userId: owner.id, title: text, isSyncedWithCloud: true);
  }
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrowException();
    final result = await db.query(userTable,where: "email = ?", whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      throw UserDoesNotExistException();
    }
    return DatabaseUser.fromRow(result.first);
  }
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrowException();
    final result = await db.query(userTable,where: "email = ?", whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyExistException();
    }
    final userId = await db.insert(userTable, {
      emailCol: email.toLowerCase()
    });

    return DatabaseUser(id: userId, email: email);
  }
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrowException();
    final result = await db.query(userTable,where: "email = ?", whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      throw UserDoesNotExistException();
    }
    db.delete(userTable, where: "email = ?", whereArgs: [email.toLowerCase()]);
  }
  Future<void> closeDatabase() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    }
    await db.close();
    _db = null;
  }
  Future<void> openDatabase() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final String dbPath = join(docsPath.path, dbName);
      final db = await sqflite.openDatabase(dbPath);
      _db = db;

      const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
	    "id"	INTEGER NOT NULL,
	    "email"	TEXT NOT NULL UNIQUE,
	    PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';

      await db.execute(createUserTable);

      const createNotesTable = ''' CREATE TABLE IF NOT EXISTS "note" (
	    "id"	INTEGER NOT NULL,
	    "user_id"	INTEGER NOT NULL,
	    "text"	TEXT,
	    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	    FOREIGN KEY("user_id") REFERENCES "user"("id"),
	    PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';

      await db.execute(createNotesTable);

    } on MissingPlatformDirectoryException {
      throw DirectoryMissingException();
    }
  }
  sqflite.Database _getDatabaseOrThrowException() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    }
    else {
      return db;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        email = map[emailCol] as String;

  @override
  String toString() => "User : ID = $id EMAIL = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String title;
  final bool isSyncedWithCloud;

  const DatabaseNote(
      {required this.id,
      required this.userId,
      required this.title,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        userId = map[userIdCol] as int,
        title = map[titleCol] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudCol] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note : ID = $id USERID = $userId ISSYNCEDWIHTCLOUD = $isSyncedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => other.id == id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idCol = "id";
const emailCol = "email";
const userIdCol = "user_id";
const titleCol = "title";
const isSyncedWithCloudCol = "is_synced_with_cloud";
