import 'package:flutter/material.dart';

import '../../../app_color.dart';

class PersonalInfo extends StatefulWidget {
  final Map<String, String> personalInfo;
  final Function(String, String) onChange;

  const PersonalInfo({
    Key? key,
    required this.personalInfo,
    required this.onChange,
  }) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // Text controllers
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with current values from personalInfo
    _nameController = TextEditingController(text: widget.personalInfo['name'] ?? '');
    _locationController = TextEditingController(text: widget.personalInfo['location'] ?? '');
    _emailController = TextEditingController(text: widget.personalInfo['email'] ?? '');
    _phoneController = TextEditingController(text: widget.personalInfo['phone'] ?? '');
    
    // Add listeners to update parent component when text changes
    _nameController.addListener(() {
      widget.onChange('name', _nameController.text);
    });
    
    _locationController.addListener(() {
      widget.onChange('location', _locationController.text);
    });
    
    _emailController.addListener(() {
      widget.onChange('email', _emailController.text);
    });
    
    _phoneController.addListener(() {
      widget.onChange('phone', _phoneController.text);
    });
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColor.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColor.border, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              const SizedBox(height: 24),
              
              // Full Name
              _buildInputField(
                label: "Full Name",
                controller: _nameController,
                placeholder: "Enter Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              
              // Location
              _buildInputField(
                label: "Location",
                controller: _locationController,
                placeholder: "Orlando, FL",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              
              // Email
              _buildInputField(
                label: "Email",
                controller: _emailController,
                placeholder: "yourname@example.com",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Phone
              _buildInputField(
                label: "Phone Number",
                controller: _phoneController,
                placeholder: "(123) 456-7890",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              
              // LinkedIn field is commented out in the original code
              // You can uncomment it if needed
              // const SizedBox(height: 16),
              // _buildInputField(
              //   label: "LinkedIn (Optional)",
              //   controller: _linkedinController, 
              //   placeholder: "linkedin.com/in/yourname",
              //   icon: Icons.link,
              // ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        
        // Input field
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: AppColor.secondaryText.withOpacity(0.5),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColor.secondaryText),
            filled: true,
            fillColor: AppColor.userBubble,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.border),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.accent, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(color: AppColor.text),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}