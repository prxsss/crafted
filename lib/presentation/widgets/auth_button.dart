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
