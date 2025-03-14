import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onAuthButtonPressed;

  const AuthButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onAuthButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          onAuthButtonPressed();
        },
        icon: FaIcon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          foregroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
