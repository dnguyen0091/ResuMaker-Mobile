// Example usage in a page
import 'package:flutter/material.dart';

import '../Widgets/navi_button.dart';
import '../app_color.dart';

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
            // App bar with title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'ResuMaker',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                  ),
                ],
              ),
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
                    child: Center(
                      child: Text(
                        'Resume Builder',
                        style: TextStyle(color: AppColor.text, fontSize: 24),
                      ),
                    ),
                  ),
                  
                  // Resume Analyzer Page
                  Container(
                    color: AppColor.background,
                    child: Center(
                      child: Text(
                        'Resume Analyzer',
                        style: TextStyle(color: AppColor.text, fontSize: 24),
                      ),
                    ),
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