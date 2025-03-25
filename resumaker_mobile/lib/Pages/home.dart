import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_assets.dart';
import '../app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // Set background color
      body: Stack(
        children: [
          // Wrap the Center and Column in a Positioned widget
          Positioned(
            top: 70, // Adjust this value to control vertical position
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.logo,
                    width: 350.0,
                    height: 350.0,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Your ultimate AI-powered tool for crafting standout resumes and optimizing your application",
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                        color: AppColor.text, // Use text color from theme
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // "Get Started" button for new users
          Positioned(
            bottom: 200, // Position above the login button
            left: 115,
            right: 115,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: AppColor.accent, // Use accent color for button
                foregroundColor: AppColor.text, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.text, // Use text color from theme
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.rightArrow,
                    width: 20,
                    height: 20,
                    color: AppColor.icon, // Use icon color from theme
                  ),
                ],
              ),
            ),
          ),
           
          // "Already a user? Login" button
          Positioned(
            bottom: 140,
            left: 115,
            right: 115,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enter_user');
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryText, // Use secondary text color
              ),
              child: Text(
                'Already a user? Login',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.secondaryText, // Use secondary text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}