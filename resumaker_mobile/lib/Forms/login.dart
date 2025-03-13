import 'package:flutter/material.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool _obscureText = true; // Initially password is obscured

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'example@example.org',
            ),
          ),
          const SizedBox(height: 16), // Add spacing between fields
          TextFormField(
            obscureText: _obscureText, // Use the state variable here
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
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
          ),
          const SizedBox(height: 24), // Add spacing before button
          ElevatedButton(
            onPressed: () {
              // Validate the form w/ endpoint

              // If successful pass to next page
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}