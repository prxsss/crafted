import 'package:crafted/presentation/widgets/auth_button.dart';
import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/sign_in_form_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInChoiceScreen extends StatelessWidget {
  const SignInChoiceScreen({
    super.key,
    required this.onNavigateToSignUpScreenPressed,
  });

  final void Function() onNavigateToSignUpScreenPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medium',
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
            const SizedBox(
              width: 280,
              child: Text(
                'Human stories and ideas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Discover perspectives that deepen understanding.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            AuthButton(
              icon: FontAwesomeIcons.google,
              text: 'Sign in with Google',
              onAuthButtonPressed: () {},
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
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    onNavigateToSignUpScreenPressed();
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.green),
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
