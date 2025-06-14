import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

// this is the events that are happening
class AuhtEventInitialize extends AuthEvent {
  const AuhtEventInitialize();
}

class AuhtEventlogIn extends AuthEvent {
  final String email;
  final String password;

  const AuhtEventlogIn(
    this.email,
    this.password,
  );
}

class AuhtEventLogOut extends AuthEvent {
  const AuhtEventLogOut();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(
    this.email,
    this.password,
  );
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
