import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/sign_up_form_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpChoiceScreen extends StatelessWidget {
  const SignUpChoiceScreen({
    super.key,
    required this.onNavigateToSignInScreenPressed,
  });

  final void Function() onNavigateToSignInScreenPressed;

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
            SignUpChoiceButton(
              icon: FontAwesomeIcons.google,
              text: 'Sign up with Google',
              onSignUpButtonPressed: () {},
            ),
            SignUpChoiceButton(
              icon: FontAwesomeIcons.envelope,
              text: 'Sign up with Email',
              onSignUpButtonPressed: () {
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
                const Text('Already have an account? '),
                TextButton(
                  onPressed: () {
                    onNavigateToSignInScreenPressed();
                  },
                  child: const Text(
                    'Sign in',
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

class SignUpChoiceButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onSignUpButtonPressed;

  const SignUpChoiceButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onSignUpButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          onSignUpButtonPressed();
        },
        icon: FaIcon(icon, color: Colors.black),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
