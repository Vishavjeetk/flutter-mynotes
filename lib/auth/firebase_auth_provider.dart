import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notes/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes/firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';

class FirebaseAuthProvider implements MyAuthProvider {
  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      }
      else if (e.code == "invalid-email") {
        throw EmailAlreadyInUseAuthException();
      }
      else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      }
      else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }


  @override
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
    else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      }
      else {
        throw UserNotLoggedInAuthException();
      }
    }
    on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      }
      else if (e.code == "wrong-password") {
        throw WrongPasswordAuthException();
      }
      else {
        throw GenericAuthException();
      }
    }
    catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    }
    else {
      return null;
    }
  }

  @override
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  @override
  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }
}
