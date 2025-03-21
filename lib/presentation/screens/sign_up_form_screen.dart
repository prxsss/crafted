import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/main.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false;

  Future signUpWithEmailAndPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      var userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      // FirebaseUser
      var newUser = userCredential.user;

      // Add the  display name to the FirebaseUser
      String newDisplayName = nameController.text;

      // Add the photoUrl to the FirebaseUser
      String photoUrl =
          'https://avatar.iran.liara.run/username?username=${nameController.text.split(' ').join('+')}';

      await newUser!.updateProfile(
        displayName: newDisplayName,
        photoURL: photoUrl,
      );

      // Refresh data
      await newUser.reload();

      // Need to make this call to get the updated display name and photoUrl; or else display name and photoUrl will be null
      auth.User updatedUser = auth.FirebaseAuth.instance.currentUser!;

      // ignore: avoid_print
      print('new display name: ${updatedUser.displayName}');
      // ignore: avoid_print
      print('new photoUrl: ${updatedUser.photoURL}');

      _databaseService.createUserInDatabaseWithEmail(updatedUser);
    } on auth.FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      String errorMessage = '';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email. Please try again.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Weak password. Please try again.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));

      navigatorKey.currentState!.pop();
      return;
    }
    navigatorKey.currentState!.popUntil(
      (route) => route.isFirst,
    ); // close dialog
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Crafted',
                  style: GoogleFonts.pressStart2p(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // style: TextStyle(
                  //   fontSize: 28,
                  //   fontWeight: FontWeight.bold,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your full name',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Input your first name and last name',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your email',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'janedoe@email.com',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your password',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Input your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon:
                                isPasswordVisible
                                    ? const FaIcon(
                                      FontAwesomeIcons.eyeSlash,
                                      size: 15,
                                    )
                                    : const FaIcon(
                                      FontAwesomeIcons.eye,
                                      size: 15,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUpWithEmailAndPassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('Create account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
