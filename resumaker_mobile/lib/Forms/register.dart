import 'package:flutter/material.dart';

import '../app_color.dart';
import './verification.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});
  
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Password requirement states
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    // Add listener to password field to check requirements in real-time
    _passwordController.addListener(_checkPasswordRequirements);
  }
  
  void _checkPasswordRequirements() {
    setState(() {
      final password = _passwordController.text;
      _hasMinLength = password.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);
      _hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  Widget _buildRequirementRow(bool isMet, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? AppColor.accent : AppColor.secondaryText,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? AppColor.accent : AppColor.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context,constraints){
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: AppColor.text),
                  cursorColor: AppColor.accent,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@example.org',
                    labelStyle: TextStyle(color: AppColor.secondaryText),
                    hintStyle: TextStyle(color: AppColor.secondaryText),
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
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: TextStyle(color: AppColor.text),
                        cursorColor: AppColor.accent,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          hintText: 'Ex. John',
                          labelStyle: TextStyle(color: AppColor.secondaryText),
                          hintStyle: TextStyle(color: AppColor.secondaryText),
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
                          prefixIcon: Icon(Icons.person_outline, color: AppColor.icon),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: TextStyle(color: AppColor.text),
                        cursorColor: AppColor.accent,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          hintText: 'Ex. Doe',
                          labelStyle: TextStyle(color: AppColor.secondaryText),
                          hintStyle: TextStyle(color: AppColor.secondaryText),
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
                          prefixIcon: Icon(Icons.person_outline, color: AppColor.icon),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: AppColor.text),
                  cursorColor: AppColor.accent,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    labelStyle: TextStyle(color: AppColor.secondaryText),
                    hintStyle: TextStyle(color: AppColor.secondaryText),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColor.icon,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!_hasMinLength || !_hasUppercase || !_hasNumber || !_hasSpecialChar) {
                      return 'Password does not meet all requirements';
                    }
                    return null;
                  },
                ),
                
                // Password requirements checklist
                if (_passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildRequirementRow(_hasMinLength, 'At least 8 characters'),
                  _buildRequirementRow(_hasUppercase, 'At least one uppercase letter'),
                  _buildRequirementRow(_hasNumber, 'At least one number'),
                  _buildRequirementRow(_hasSpecialChar, 'At least one special character'),
                ],
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(color: AppColor.text),
                  cursorColor: AppColor.accent,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    labelStyle: TextStyle(color: AppColor.secondaryText),
                    hintStyle: TextStyle(color: AppColor.secondaryText),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColor.icon,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Proceed with registration
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyUser(
                              email: _emailController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accent,
                      foregroundColor: AppColor.text,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Register', 
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.removeListener(_checkPasswordRequirements);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}