import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

// The variables of this class will never change
@immutable
class AuthUser {
  final bool isEmailVerified;

// const beacuse the attr is a final (not null and will not change once set)
  const AuthUser(
    this.isEmailVerified,
  );

// If this AuthUser class is called it will be created with the given user
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
