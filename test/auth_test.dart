import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialize, false);
    });
    test('Cannot Log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    });

    test('User should be null after initialized', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to inititalized within 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialize, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delicate login to function', () async {
      final badEmailUserr = provider.createUser(
        email: provider.badEmail,
        password: 'somePassword',
      );
      expect(
          badEmailUserr, throwsA(const TypeMatcher<UserNotFoundException>()));

      final badPasswordUser = provider.createUser(
        email: 'someEmail',
        password: provider.badPassword,
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('A Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and login agian', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user; // is null by default
  var _isInitialized = false; // If '_' is infront a variable it is private
  bool get isInitialize => _isInitialized;
  final badEmail = 'foo@bar.baz';
  final badPassword = 'foobar';

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialize) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialize) throw NotInitializedException();
    if (email == badEmail) throw UserNotFoundException();
    if (password == badPassword) throw WrongPasswordException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialize) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialize) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
