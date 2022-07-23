import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mynotes/constants/route.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
// import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // CloseDialog? _closeDialogHandel;

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
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Please enter your email and password to lgoin to the app.'),
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuhtEventlogIn(
                                email,
                                password,
                              ),
                            );
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventForgotPassword(),
                            );
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   registerRout,
                        //   (route) => false,
                        // ),
                      },
                      child: const Text('I forgot my password'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventShouldRegister(),
                            );
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   registerRout,
                        //   (route) => false,
                        // ),
                      },
                      child: const Text('Not Registered yet? Register here!'),
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

                  // await AuthService.firebase().logIn(
                  //   email: email,
                  //   password: password,
                  // );
                  // final user = AuthService.firebase().currentUser;
                  // if (user?.isEmailVerified ?? false) {
                  //   if (mounted) {
                  //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //       notesRout,
                  //       (route) => false,
                  //     );

                  // } else {
                  //   if (mounted) {
                  //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //       verifyEmailRout,
                  //       (route) => false,
                  //     );
                  //   }
                  // }
                  // } on UserNotFoundException {
                  //   showErrorDialog(
                  //     context,
                  //     'User not found',
                  //   );
                  // } on WrongPasswordException {
                  //   showErrorDialog(
                  //     context,
                  //     'Wrong credentials',
                  //   );
                  // } on GenericAuthException {
                  //   showErrorDialog(
                  //     context,
                  //     'Authentication Error',
                  //   );
                  // }
