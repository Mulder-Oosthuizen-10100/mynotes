import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

// used when app initialize and when the user presses login button
// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateUninitialize extends AuthState {
  const AuthStateUninitialize();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.isLoading,
    required this.exception,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

// class AuthStateLogOutFailer extends AuthState {
//   final Exception exception;
//   const AuthStateLogOutFailer(this.exception);
// }
