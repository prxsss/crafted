import 'package:crafted/presentation/screens/sign_up_choice_screen.dart';
import 'package:crafted/presentation/screens/sign_in_choice_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var activeScreen = 'sign_up_screen';

  void switchScreen() {
    setState(() {
      activeScreen =
          activeScreen == 'sign_up_screen'
              ? 'sign_in_screen'
              : 'sign_up_screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = SignUpChoiceScreen(
      onNavigateToSignInScreenPressed: switchScreen,
    );

    if (activeScreen == 'sign_in_screen') {
      screenWidget = SignInChoiceScreen(
        onNavigateToSignUpScreenPressed: switchScreen,
      );
    }

    return screenWidget;
  }
}
