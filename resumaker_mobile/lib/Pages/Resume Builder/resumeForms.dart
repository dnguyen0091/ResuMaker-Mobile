import 'package:flutter/material.dart';

import '../../app_color.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({Key? key}) : super(key: key);

  @override
  State<ResumeBuilder> createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        foregroundColor: AppColor.text,
        elevation: 0,
        title: const Text(
          "Resume Builder",
          style: TextStyle(
            color: AppColor.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _previewResume();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            Step(
              title: const Text('Personal Information', style: TextStyle(color: AppColor.text)),
              content: _buildPersonalInfoForm(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Education', style: TextStyle(color: AppColor.text)),
              content: _buildEducationForm(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Experience', style: TextStyle(color: AppColor.text)),
              content: _buildExperienceForm(),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Skills', style: TextStyle(color: AppColor.text)),
              content: _buildSkillsForm(),
              isActive: _currentStep >= 3,
            ),
          ],
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accent,
                      foregroundColor: AppColor.text,
                    ),
                    child: Text(_currentStep < 3 ? 'Continue' : 'Preview'),
                  ),
                  if (_currentStep > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: details.onStepCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColor.secondaryText,
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            labelStyle: TextStyle(color: AppColor.secondaryText),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.accent),
            ),
          ),
          style: const TextStyle(color: AppColor.text),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            labelStyle: TextStyle(color: AppColor.secondaryText),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.accent),
            ),
          ),
          style: const TextStyle(color: AppColor.text),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: AppColor.secondaryText),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.accent),
            ),
          ),
          style: const TextStyle(color: AppColor.text),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
  
  Widget _buildEducationForm() {
    return TextFormField(
      controller: _educationController,
      decoration: const InputDecoration(
        labelText: 'Education Details',
        labelStyle: TextStyle(color: AppColor.secondaryText),
        hintText: 'Degree, Institution, Year',
        hintStyle: TextStyle(color: AppColor.secondaryText, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.accent),
        ),
      ),
      style: const TextStyle(color: AppColor.text),
      maxLines: 5,
    );
  }
  
  Widget _buildExperienceForm() {
    return TextFormField(
      controller: _experienceController,
      decoration: const InputDecoration(
        labelText: 'Work Experience',
        labelStyle: TextStyle(color: AppColor.secondaryText),
        hintText: 'Position, Company, Duration, Responsibilities',
        hintStyle: TextStyle(color: AppColor.secondaryText, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.accent),
        ),
      ),
      style: const TextStyle(color: AppColor.text),
      maxLines: 8,
    );
  }
  
  Widget _buildSkillsForm() {
    return TextFormField(
      controller: _skillsController,
      decoration: const InputDecoration(
        labelText: 'Skills',
        labelStyle: TextStyle(color: AppColor.secondaryText),
        hintText: 'Enter your skills separated by commas',
        hintStyle: TextStyle(color: AppColor.secondaryText, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.accent),
        ),
      ),
      style: const TextStyle(color: AppColor.text),
      maxLines: 3,
    );
  }
  
  void _previewResume() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would generate a PDF here
      // For now, just show a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColor.card,
          title: const Text(
            'Resume Preview',
            style: TextStyle(color: AppColor.text),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_emailController.text} | ${_phoneController.text}',
                  style: const TextStyle(color: AppColor.secondaryText),
                ),
                const Divider(color: AppColor.border),
                const Text(
                  'Education',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                ),
                Text(
                  _educationController.text,
                  style: const TextStyle(color: AppColor.text),
                ),
                const Divider(color: AppColor.border),
                const Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                ),
                Text(
                  _experienceController.text,
                  style: const TextStyle(color: AppColor.text),
                ),
                const Divider(color: AppColor.border),
                const Text(
                  'Skills',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                ),
                Text(
                  _skillsController.text,
                  style: const TextStyle(color: AppColor.text),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryText,
              ),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Resume saved successfully!',
                      style: TextStyle(color: AppColor.text),
                    ),
                    backgroundColor: AppColor.card,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accent,
                foregroundColor: AppColor.text,
              ),
              child: const Text('Save Resume'),
            ),
          ],
        ),
      );
    }
  }
}