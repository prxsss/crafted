import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/main_layout.dart';
import 'package:crafted/presentation/screens/auth_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (snapshot.hasData) {
          return const MainLayout();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
