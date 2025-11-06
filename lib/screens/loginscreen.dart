import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantsmart/screens/signupscreen.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? _errorMessage;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = null;
    });

    if (_validateAndSave()) {
      setState(() {
        isLoading = true;
      });
      try {
        await signInWithEmailAndPassword();
      } catch (e) {
        setState(() {
          isLoading = false;
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'user-not-found':
                _errorMessage = "No user found for that email.";
                break;
              case 'wrong-password':
                _errorMessage = "Incorrect password provided for that email.";
                break;
              case 'invalid-email':
                _errorMessage = "The email address is not valid.";
                break;
              default:
                _errorMessage = "Wrong Email or Password";
                break;
            }
          } else {
            _errorMessage = "An unexpected error occurred.";
          }
        });
      }
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign In Successful"),
            content: Text("You have successfully signed in!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7EB),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign In',
                style: TextStyle(color: Colors.green, fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: _inputDecoration('Email'),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : !value.contains('@') ? 'Please enter a valid email address' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Password', isPassword: true),
                obscureText: _obscureText,
                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                ),
                onPressed: _validateAndSubmit,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Don’t have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );

                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      )
          : null,
    );
  }
}
