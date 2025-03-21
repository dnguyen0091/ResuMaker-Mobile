import 'package:flutter/material.dart';

import '../Widgets/header.dart';
import '../Widgets/navi_button.dart';
import '../app_color.dart';
import 'Resume Analyzer/resumeAnalyzer.dart'; // Import the ResumeAnalyzer
import 'Resume Builder/resumeBuilder.dart'; // Import the ResumeBuilder

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentTab = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Use the Header widget with capital H
            const Header(
              showBackButton: false,
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
                children: [
                  // Resume Builder Page
                  Container(
                    color: AppColor.background,
                    child: const ResumeBuilder(),
                  ),
                  
                  // Resume Analyzer Page - Replace placeholder with actual component
                  Container(
                    color: AppColor.background,
                    child: const ResumeAnalyzer(),
                  ),
                ],
              ),
            ),
            // Navigation slider
            NaviButton(
              initialTab: _currentTab,
              onTabChanged: _handleTabChange,
            ),
          ],
        ),
      ),
    );
  }
}