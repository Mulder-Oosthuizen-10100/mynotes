import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

// used when app initialize and when the user presses login button
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateLoginFailure(this.exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailer extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailer(this.exception);
}
