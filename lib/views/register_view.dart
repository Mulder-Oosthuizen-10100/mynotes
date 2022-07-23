import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mynotes/constants/route.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlradyInUseException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GeneralAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'To register as a user please enter an email and passowrd'),
              TextField(
                controller: _email,
                enableSuggestions: true,
                autocorrect: false,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegister(
                                email,
                                password,
                              ),
                            );
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuhtEventLogOut(),
                            );
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   loginRout,
                        //   (route) => false,
                        // );
                      },
                      child: const Text('Already register? Logon here!'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


                  // try {
                  //   await AuthService.firebase().createUser(
                  //     email: email,
                  //     password: password,
                  //   );
                  //   AuthService.firebase().sendEmailVerification();

                  //   if (mounted) {
                  //     Navigator.of(context).pushNamed(
                  //       verifyEmailRout,
                  //     );
                  //   }
                  // } on WrongPasswordException {
                  //   await showErrorDialog(
                  //     context,
                  //     'Weak Password',
                  //   );
                  // } on EmailAlradyInUseException {
                  //   await showErrorDialog(
                  //     context,
                  //     'Email is already in use',
                  //   );
                  // } on InvalidEmailException {
                  //   await showErrorDialog(
                  //     context,
                  //     'This is an invalid email address',
                  //   );
                  // } on GenericAuthException {
                  //   await showErrorDialog(
                  //     context,
                  //     'Failed to register',
                  //   );
                  // }
