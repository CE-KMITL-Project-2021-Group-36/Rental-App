import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/providers/authentication_provider.dart';
import 'package:rental_app/screens/register_with_google_screen.dart';
import 'package:rental_app/screens/verify_email_screen.dart';

import 'error_screen.dart';
import 'login_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) {
            if (FirebaseAuth.instance.currentUser!.isAnonymous) {
              return const VerifyEmailPage();
            } else if (FirebaseAuth
                    .instance.currentUser!.providerData.first.providerId ==
                'google.com') {
              return const RegisterWithGoogleScreen();
            } else {
              return const VerifyEmailPage();
            }
          }
          return const LoginPage();
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}
