import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:crafted/presentation/screens/auth_wrapper.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xffd08700));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.surface,
        appBarTheme: AppBarTheme().copyWith(
          foregroundColor: kColorScheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: kColorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kColorScheme.primary),
        ),
        inputDecorationTheme: InputDecorationTheme().copyWith(
          suffixIconColor: kColorScheme.primary,
          errorStyle: TextStyle().copyWith(color: kColorScheme.error),
          hintStyle: TextStyle().copyWith(color: kColorScheme.onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          filled: true,
          fillColor: kColorScheme.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: kColorScheme.primary, width: 1.5),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
          backgroundColor: kColorScheme.surface,
          selectedItemColor: kColorScheme.primary,
          unselectedItemColor: kColorScheme.onSurfaceVariant,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
