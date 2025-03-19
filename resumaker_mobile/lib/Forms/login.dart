import 'package:flutter/material.dart';

import '../app_color.dart';
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
            style: TextStyle(color: AppColor.text), // Text color
            cursorColor: AppColor.accent, // Cursor color
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'example@example.org',
              labelStyle: TextStyle(color: AppColor.secondaryText),
              hintStyle: TextStyle(color: AppColor.secondaryText),
              // Add error styling
              errorStyle: const TextStyle(color: Colors.red),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.accent),
              ),
              filled: true,
              fillColor: AppColor.inputField,
              prefixIcon: Icon(Icons.email_outlined, color: AppColor.icon),
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
            style: TextStyle(color: AppColor.text), // Text color
            cursorColor: AppColor.accent, // Cursor color
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              labelStyle: TextStyle(color: AppColor.secondaryText),
              hintStyle: TextStyle(color: AppColor.secondaryText),
              // Add error styling
              errorStyle: const TextStyle(color: Colors.red),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.accent),
              ),
              filled: true,
              fillColor: AppColor.inputField,
              prefixIcon: Icon(Icons.lock_outline, color: AppColor.icon),
              // Add a button to toggle password visibility
              suffixIcon: IconButton(
                icon: Icon(
                  // Change the icon based on the state
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.icon,
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
              backgroundColor: AppColor.accent,
              foregroundColor: AppColor.text,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                color: AppColor.text,
              ),
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
                  MaterialPageRoute(builder: (context) => const ForgotPassword()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryText,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: AppColor.secondaryText),
              ),
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
    
    // Here you would call your API endpoint for authentication
    // For example:
    // authService.login(email, password).then((success) {
    //   if (success) {
    //     Navigator.pushReplacementNamed(context, '/home');
    //   } else {
    //     // Show login failure message
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Login failed. Please check your credentials.', 
    //           style: TextStyle(color: AppColor.text)),
    //         backgroundColor: AppColor.card,
    //       ),
    //     );
    //   }
    // });
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}