import 'package:flutter_notes/auth/auth_user.dart';
import 'package:flutter_notes/auth/firebase_auth_provider.dart';

import '../../auth/auth_provider.dart';

class AuthService implements MyAuthProvider {
  final MyAuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      provider.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      provider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> initializeApp() => provider.initializeApp();

  @override
  Future<void> reload() => provider.reload();
}
