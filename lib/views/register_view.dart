import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/route.dart';

class RegiserView extends StatefulWidget {
  const RegiserView({Key? key}) : super(key: key);

  @override
  State<RegiserView> createState() => _RegiserViewState();
}

class _RegiserViewState extends State<RegiserView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final usercredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                devtools.log(usercredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  devtools.log('Weak password');
                } else if (e.code == 'email-already-in-use') {
                  devtools.log('Email already in use');
                } else if (e.code == 'invalid-email') {
                  devtools.log('Invalid email entered');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRout,
                (route) => false,
              );
            },
            child: const Text('Already register? Logon here!'),
          ),
        ],
      ),
    );
  }
}
