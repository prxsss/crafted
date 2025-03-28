import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/presentation/widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/sign_up_form_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpChoiceScreen extends StatelessWidget {
  SignUpChoiceScreen({
    super.key,
    required this.onNavigateToSignInScreenPressed,
  });

  final DatabaseService _databaseService = DatabaseService();

  final void Function() onNavigateToSignInScreenPressed;

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
        title: Text(
          'Crafted',
          style: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                style: GoogleFonts.pressStart2p(
                  textStyle: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // style: TextStyle(
                //   fontSize: 48,
                //   fontWeight: FontWeight.w600,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
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
              text: 'Sign up with Google',
              onAuthButtonPressed: signInWithGoogle,
            ),
            AuthButton(
              icon: FontAwesomeIcons.envelope,
              text: 'Sign up with Email',
              onAuthButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpFormScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onNavigateToSignInScreenPressed();
                  },
                  child: Text(
                    'Sign in',
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

// class SignUpChoiceButton extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final void Function() onSignUpButtonPressed;

//   const SignUpChoiceButton({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.onSignUpButtonPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ElevatedButton.icon(
//         onPressed: () {
//           onSignUpButtonPressed();
//         },
//         icon: FaIcon(icon),
//         label: Text(text),
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//         ),
//       ),
//     );
//   }
// }
