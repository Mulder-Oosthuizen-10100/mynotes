import 'package:flutter/material.dart';
import 'package:mynotes/constants/route.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you haven't reveived a verification email yet, press the button below"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );

              // await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuhtEventLogOut(),
                  );

              // await AuthService.firebase().logOut();
              // if (mounted) {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              // registerRout,
              // (route) => false,
              // );
              // }
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
