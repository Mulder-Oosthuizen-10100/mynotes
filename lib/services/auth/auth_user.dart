import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

// The variables of this class will never change
@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

// const beacuse the attr is a final (not null and will not change once set)
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  }); // required makes the bellow possible
// void testing {
  // AuthUser(isEmailVerified: true);
// }

// If this AuthUser class is called it will be created with the given user
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
