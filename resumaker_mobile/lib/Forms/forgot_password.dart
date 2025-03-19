import 'package:flutter/material.dart';

import '../app_color.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Forgot Password', style: TextStyle(color: AppColor.text)),
        centerTitle: true,
        backgroundColor: AppColor.card,
        iconTheme: IconThemeData(color: AppColor.icon),
      ),
      // Use resizeToAvoidBottomInset to ensure form moves above keyboard
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          // Allow tapping anywhere to dismiss keyboard
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              // Padding to ensure content adjusts when keyboard appears
              padding: EdgeInsets.only(
                left: 24, 
                right: 24,
                top: 16,
                // Add bottom padding that's at least the keyboard height
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon for visual appeal
                    Icon(
                      Icons.lock_reset,
                      size: 80,
                      color: AppColor.accent,
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Enter your email address and we will send you a password reset link',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: AppColor.text),
                      cursorColor: AppColor.accent,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
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
                        if(!checkForEmail()) {
                          return 'Email not found';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Send reset password email
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Reset link sent to your email',
                                  style: TextStyle(color: AppColor.text),
                                ),
                                backgroundColor: AppColor.card,
                              ),
                            );
                            
                            // Navigate back to login after a delay
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.accent,
                          foregroundColor: AppColor.text,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.text,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColor.secondaryText,
                      ),
                      child: Text(
                        'Back to Login',
                        style: TextStyle(color: AppColor.secondaryText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  //Checks for email in DB
  bool checkForEmail() {
    //Check for email in DB
    return true;
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}