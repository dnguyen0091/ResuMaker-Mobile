import 'package:flutter/material.dart';

import '../app_assets.dart';
import '../app_color.dart';
import 'savedResumes.dart'; // Import the SavedResumes widget

class Header extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  const Header({
    Key? key,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColor.primaryColor,
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColor.icon,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          // const SizedBox(width: 12),
          Image.asset(Assets.logoIcon,width: 40,height: 40, fit: BoxFit.contain,),
          const SizedBox(width: 12),
          Text(
            'ResuMaker',
            style: TextStyle(
              color: AppColor.text,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.account_circle,
              color: AppColor.icon,
            ),
            offset: const Offset(0, 40),
            color: AppColor.card,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'savedResumes',
                child: Text(
                  'Saved Resumes',
                  style: TextStyle(color: AppColor.text),
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0)),
                ),
              ),
            ],
            onSelected: (String value) {
              // Handle menu item selection
              switch (value) {
                case 'savedResumes':
                  // Show SavedResumes as overlay
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.transparent, // Fully transparent background
                    builder: (context) => SavedResumes(
                      closePopup: () => Navigator.of(context).pop(),
                    ),
                  );
                  break;
                case 'logout':
                  // Handle logout
                  // Example: Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: AppColor.card,
                      title: Text(
                        'Logout',
                        style: TextStyle(color: AppColor.text),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(color: AppColor.text),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColor.secondaryText),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform logout
                            Navigator.pop(context);
                            // Then navigate to login page
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}