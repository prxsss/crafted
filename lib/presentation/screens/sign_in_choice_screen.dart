import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/presentation/widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/sign_in_form_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInChoiceScreen extends StatelessWidget {
  SignInChoiceScreen({
    super.key,
    required this.onNavigateToSignUpScreenPressed,
  });

  final DatabaseService _databaseService = DatabaseService();

  final void Function() onNavigateToSignUpScreenPressed;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final auth.User user =
        (await auth.FirebaseAuth.instance.signInWithCredential(
          credential,
        )).user!;

    print('Successfully signed in with Google: ${user.displayName}');

    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser!;

    if (firebaseUser.metadata.creationTime!
            .difference(firebaseUser.metadata.lastSignInTime!)
            .abs() <
        Duration(seconds: 1)) {
      print('Creating new user in Database');

      _databaseService.createUserInDatabaseWithEmail(firebaseUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crafted',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 280,
              child: Text(
                'Human stories and ideas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Discover perspectives that deepen understanding.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 40),
            AuthButton(
              icon: FontAwesomeIcons.google,
              text: 'Sign in with Google',
              onAuthButtonPressed: () async {
                await signInWithGoogle();
              },
            ),
            AuthButton(
              icon: FontAwesomeIcons.envelope,
              text: 'Sign in with Email',
              onAuthButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInFormScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onNavigateToSignUpScreenPressed();
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
