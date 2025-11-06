import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        await signUpWithEmailAndPassword();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign Up Successful"),
              content: Text("You have successfully signed up!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error signing up: $e');
      }
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      // Create user with email and password
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The account already exists for that email."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred while signing up."),
          ),
        );
      }
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7EB),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.green, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Username'),
                    validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Email'),
                    validator: (value) => value!.isEmpty ? 'Please enter your email' : !value.contains('@') ? 'Please enter a valid email address' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Phone Number'),
                    validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Password', isPassword: true, isPasswordConfirmation: false),
                    obscureText: _obscureTextPassword,
                    validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Confirm Password', isPassword: true, isPasswordConfirmation: true),
                    obscureText: _obscureTextConfirmPassword,
                    validator: (value) => value!.isEmpty ? 'Please confirm your password' : value != _passwordController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green,
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {bool isPassword = false, bool isPasswordConfirmation = false}) {
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
          isPasswordConfirmation ? (_obscureTextConfirmPassword ? Icons.visibility_off : Icons.visibility) : (_obscureTextPassword ? Icons.visibility_off : Icons.visibility),
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            if (isPasswordConfirmation) {
              _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
            } else {
              _obscureTextPassword = !_obscureTextPassword;
            }
          });
        },
      )
          : null,
    );
  }
}
