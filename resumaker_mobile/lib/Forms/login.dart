import 'package:flutter/material.dart';

import './forgot_password.dart';
class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool _obscureText = true; // Initially password is obscured
  final _formKey = GlobalKey<FormState>(); // Add form key
  
  // Add controllers to access field values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Attach the key to the form
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Make elements fill width
        children: [
          TextFormField(
            controller: _emailController, // Attach controller
            keyboardType: TextInputType.emailAddress, // Set keyboard type
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'example@example.org',
              // Add error styling
              errorStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16), // Add spacing between fields
          TextFormField(
            controller: _passwordController, // Attach controller
            obscureText: _obscureText, // Use the state variable here
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              // Add error styling
              errorStyle: const TextStyle(color: Colors.red),
              border: const OutlineInputBorder(),
              // Add a button to toggle password visibility
              suffixIcon: IconButton(
                icon: Icon(
                  // Change the icon based on the state
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // Toggle the state when pressed
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 24), // Add spacing before button
          ElevatedButton(
            onPressed: () {
              // Validate all form fields
              if (_formKey.currentState!.validate()) {
                // Only proceed if validation passes
                validateLogin();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16),
            ),
          ),
          
          // Add a forgot password option
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton(
              onPressed: () {
                // Handle forgot password
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                );
              },
              child: const Text('Forgot Password?'),
            ),
          ),
        ],
      ),
    );
  }

  void validateLogin() {
    // Now you can access the values using the controllers
    final email = _emailController.text;
    final password = _passwordController.text;
    
    print('Login attempt with email: $email');
    
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}