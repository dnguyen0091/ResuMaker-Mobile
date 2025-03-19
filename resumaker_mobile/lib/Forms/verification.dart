import 'package:flutter/material.dart';

import '../app_color.dart';

class VerifyUser extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  
  const VerifyUser({
    super.key, 
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  State<VerifyUser> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerifyUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Verify Your Email', style: TextStyle(color: AppColor.text)),
        centerTitle: true,
        backgroundColor: AppColor.card,
        iconTheme: IconThemeData(color: AppColor.icon),
      ),
      // Use resizeToAvoidBottomInset to ensure form moves above keyboard
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          // Add this to allow tapping anywhere to dismiss keyboard
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              // Padding to ensure content adjusts when keyboard appears
              padding: EdgeInsets.only(
                left: 16, 
                right: 16,
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
                    // Icon or image for visual appeal
                    Icon(
                      Icons.email_outlined,
                      size: 80,
                      color: AppColor.accent,
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      'Verification code has been sent to:',
                      style: TextStyle(fontSize: 16, color: AppColor.text),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    TextFormField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                        color: AppColor.text,
                      ),
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        labelStyle: TextStyle(color: AppColor.secondaryText),
                        hintText: '123456',
                        hintStyle: TextStyle(color: AppColor.secondaryText),
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
                        counterText: "", // Hide the counter
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the verification code';
                        }
                        if (value.length != 6) {
                          return 'Verification code should be 6 digits';
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
                            _verifyCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColor.accent,
                          foregroundColor: AppColor.text,
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 16, color: AppColor.text),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code?",
                          style: TextStyle(color: AppColor.secondaryText),
                        ),
                        TextButton(
                          onPressed: _resendCode,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColor.accent,
                          ),
                          child: Text(
                            'Resend',
                            style: TextStyle(color: AppColor.accent),
                          ),
                        ),
                      ],
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

  void _verifyCode() {
    // Verification logic...
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verifying...', style: TextStyle(color: AppColor.text)),
        backgroundColor: AppColor.card,
      ),
    );
  }
  
  void _resendCode() {
    // Resend code logic...
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New verification code sent', style: TextStyle(color: AppColor.text)),
        backgroundColor: AppColor.card,
      ),
    );
  }
  
  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }
}