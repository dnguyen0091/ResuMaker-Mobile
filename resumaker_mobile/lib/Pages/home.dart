import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_assets.dart';
import '../app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(height: 10), // Increased spacing above the text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30), // Add padding on sides
                    child: const Text(
                      "Your ultimate AI-powered tool for crafting standout resumes, optimizing your application, and acing your next interview.",
                      style: TextStyle(
                        fontSize: 18, // Slightly smaller font size
                        height: 1.4, // Add line spacing
                        letterSpacing: 0.5, // Add letter spacing
                        fontWeight: FontWeight.w400, // Slightly lighter weight
                        color: Colors.black87, // Slightly softer color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20), // Add spacing below the text
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
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: AppColor.accentLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.rightArrow,
                    width: 20,
                    height: 20,
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
                Navigator.pushNamed(context, '/second');
              },
              child: const Text(
                'Already a user? Login',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}