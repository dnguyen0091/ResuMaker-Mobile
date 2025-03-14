import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        centerTitle: true,
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
                    const Icon(
                      Icons.email_outlined,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      'Verification code has been sent to:',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    TextFormField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                      ),
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        hintText: '123456',
                        border: OutlineInputBorder(),
                        counterText: "", // Hide the counter
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
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't receive the code?"),
                        TextButton(
                          onPressed: _resendCode,
                          child: const Text('Resend'),
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
      const SnackBar(content: Text('Verifying...')),
    );
  }
  
  void _resendCode() {
    // Resend code logic...
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New verification code sent')),
    );
  }
  
  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }
}