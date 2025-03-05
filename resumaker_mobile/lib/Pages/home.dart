import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/assets/placeholders/100x100.png',
                  width: 100.0,
                  height: 100.0,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Welcome to ResuMaker!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your ultimate AI-powered tool for crafting standout resumes, optimizing your application, and acing your next interview.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 125,
            right: 125,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 50),
                
              ),
              // Using flutter_svg for svg image
              child: Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}