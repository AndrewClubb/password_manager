import 'package:flutter/material.dart';
import '../services/auth.dart';


import 'home_page.dart';
import '../utils/string_validator.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Form(
        key: _formKey,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email address'),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmailAddress,
            ),
            TextFormField(
              controller: _pwController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: validatePassword,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await Auth.createAccountWithEmailAndPassword(
                        email: _emailController.text,
                        password: _pwController.text);
                    if (result == null) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => HomePage()),
                          (_) => false,
                      );
                    } else {
                      setState(() {
                        _errorMessage = result;
                      });
                    }
                  }
                },
                child: const Text('Create Account')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }
}