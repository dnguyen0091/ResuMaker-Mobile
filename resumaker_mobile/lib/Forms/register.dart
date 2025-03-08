import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});
  
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool _obscurePassword = true; // Initially password is obscured
  bool _obscureConfirmPassword = true; // Initially confirm password is obscured

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
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'John',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Doe',
                  ),
                ),
              ),
            ]
          ),
          
          const SizedBox(height: 16), // Add spacing between fields
          
          TextFormField(
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              // Add button to toggle password visibility
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          
          const SizedBox(height: 16), // Add spacing between fields
          
          TextFormField(
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Password',
              // Add button to toggle confirm password visibility
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              // Handle registration
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}