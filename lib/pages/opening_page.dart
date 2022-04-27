import 'package:flutter/material.dart';
import 'package:password_manager/pages/create_account_page.dart';
import 'package:password_manager/pages/sign_in_account_page.dart';
import 'package:password_manager/services/my_controller.dart';

import 'google_sign_in_page.dart';
import 'home_page.dart';

class OpeningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyController.isSignedIn() ? HomePage() : _openingPage(context);
  }

  Widget _openingPage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignInAccountPage()));
                },
                child: const Text('Login')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateAccountPage()));
              },
              child: const Text('Create Account')),
            const Text('or'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GoogleSignInPage()));
                },
                child: const Text('Sign in with Google')),
          ]
        ),
      ),
    );
  }
}