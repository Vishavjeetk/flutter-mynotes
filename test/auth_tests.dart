import 'package:flutter_notes/auth/auth_exceptions.dart';
import 'package:flutter_notes/auth/auth_provider.dart';
import 'package:flutter_notes/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Auth Provider Test", () {
    final provider = MyMockAuthProvider();

    test("App Should not be initialized in the beginning", () {
      expect(provider._isInitialized, false);
    });

    test("Should not be able to log before Initialization", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<AppNotInitializedAuthException>()));
    });

    test("Should be able to Initialize", () async {
      await provider.initializeApp();
      expect(provider._isInitialized, true);
    });

    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test("Should be able to initialize in less than 2 seconds", () async {
      await provider.initializeApp();
      expect(provider._isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Should be able to create user after initialization", () async {
      final badEmail = provider.createUserWithEmailAndPassword(
          email: "hello.com", password: "password");
      expect(badEmail, throwsA(const TypeMatcher<InvalidEmailAuthException>()));
      final badPassword = provider.createUserWithEmailAndPassword(
          email: "any", password: "abc");
      expect(
          badPassword, throwsA(const TypeMatcher<WeakPasswordAuthException>()));
      final user = await provider.createUserWithEmailAndPassword(
          email: "vishavjeet@gmail.com", password: "password");
      expect(user, provider.currentUser);
      expect(user.isEmailVerified, false);
    });

    test("After Sending email it should turn to true", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user!.isEmailVerified, true);
    });

    test("Check LogIn and LogOut again", () async {
      await provider.logOut();
      final user = provider.currentUser;
      expect(user, null);
      final userA = provider.signInWithEmailAndPassword(email: "vishavjeet@gmail.com", password: "password");
      expect(userA, isNotNull);
    });

  });
}

class MyMockAuthProvider implements MyAuthProvider {
  AuthUser? _user;
  var _isAppInitialized = false;
  bool get _isInitialized => _isAppInitialized;

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw AppNotInitializedAuthException();
    //await Future.delayed(const Duration(seconds: 1));
    return signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAppInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw AppNotInitializedAuthException();
    if (_user == null) UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> reload() {
    // TODO: implement reload
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw AppNotInitializedAuthException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw AppNotInitializedAuthException();
    await Future.delayed(const Duration(seconds: 1));
    if (email == "hello.com") throw InvalidEmailAuthException();
    if (password == "abc") throw WeakPasswordAuthException();
    const newUser = AuthUser(isEmailVerified: false);
    _user = newUser;
    return Future.value(_user);
  }
}
