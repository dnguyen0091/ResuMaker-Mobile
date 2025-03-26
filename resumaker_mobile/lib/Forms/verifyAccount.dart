import 'package:flutter/material.dart';

import '../app_color.dart';

class VerifyAccount extends StatefulWidget {
  final String email;
  final String password;
  
  const VerifyAccount({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  
  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text('Verify Account', style: TextStyle(color: AppColor.text)),
        centerTitle: true,
        backgroundColor: AppColor.card,
        iconTheme: const IconThemeData(color: AppColor.icon),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16, 
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon for user verification
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: AppColor.accent,
                    ),
                    const SizedBox(height: 32),
                    
                    // Instruction text
                    const Text(
                      'Enter the verification code sent to:',
                      style: TextStyle(fontSize: 16, color: AppColor.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Verification Code field
                    TextFormField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                        color: AppColor.text,
                      ),
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        labelStyle: const TextStyle(color: AppColor.secondaryText),
                        hintText: '123456',
                        hintStyle: const TextStyle(color: AppColor.secondaryText),
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
                        counterText: "",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the verification code';
                        }
                        if (value.length != 6) {
                          return 'Code must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Verify button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _verifyAccount();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColor.accent,
                        ),
                        child: const Text(
                          'Verify and Log In',
                          style: TextStyle(fontSize: 16, color: AppColor.text),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Resend code option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive a code?",
                          style: TextStyle(color: AppColor.secondaryText),
                        ),
                        TextButton(
                          onPressed: _resendCode,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColor.accent,
                          ),
                          child: const Text(
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
  
  void _verifyAccount() {
    // Replace with your verification logic for logging in the user.
    // For now, we just show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verifying account...'),
        backgroundColor: AppColor.card,
      ),
    );
  }
  
  void _resendCode() {
    // Replace with your Resend Code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new verification code was sent'),
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