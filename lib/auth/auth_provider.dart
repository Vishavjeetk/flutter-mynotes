import 'auth_user.dart';

abstract class MyAuthProvider {

  Future<void> reload();

  Future<void> initializeApp();

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  AuthUser? get currentUser;
}
