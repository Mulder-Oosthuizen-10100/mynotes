import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialize()) {
    // Send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      // there is no user intercation thus emit state that app is in
      emit(state);
    });

    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );

    // initialize
    on<AuhtEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
              exception: null,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(
              user)); // user is not const therefore we cannot call const AuthStateLoggedIn
        }
      },
    );
    // log in
    on<AuhtEventlogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            isLoading: true,
            exception: null,
          ),
        );
        final email = event.email;
        final password = event.password;

        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );

          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                isLoading: false,
                exception: null,
              ),
            );
            emit(const AuthStateNeedsVerification());
          } else {
            emit(
              const AuthStateLoggedOut(
                isLoading: false,
                exception: null,
              ),
            );
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              isLoading: false,
              exception: e,
            ),
          );
        }
      },
    );

    on<AuhtEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
              exception: null,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              isLoading: false,
              exception: e,
            ),
          );
        }
      },
    );
  }
}
