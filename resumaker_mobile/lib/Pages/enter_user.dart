import 'package:flutter/material.dart';

import '../Forms/login.dart';
import '../Forms/register.dart';
import '../app_color.dart';

class EnterUser extends StatefulWidget {
  const EnterUser({super.key});

  @override
  State<EnterUser> createState() => _EnterUserState();
}

class _EnterUserState extends State<EnterUser> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild on tab change
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: Column(
          children: [
            // Add back button row at the top
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.icon,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/'); // Navigate back to home
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20), // Reduced height since we have the back button row now
            
            // Animated custom tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.inputField,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: AppColor.border, width: 1.0),
                ),
                child: Stack(
                  children: [
                    // Animated selection indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: _tabController.index * (MediaQuery.of(context).size.width - 80) / 2,
                      top: 0,
                      bottom: 0,
                      width: (MediaQuery.of(context).size.width - 80) / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.accent,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    // Tab bar (without its own indicator)
                    TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(), // No indicator
                      dividerColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      labelColor: AppColor.text,
                      unselectedLabelColor: AppColor.secondaryText,
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Register'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Tab bar view for forms
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login form
                  Container(
                    color: AppColor.background,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20), // Reduced height
                          Expanded(child: LoginUser()),
                        ]
                      ) 
                    ),
                  ),
                  
                  // Register form
                  Container(
                    color: AppColor.background,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20), // Reduced height
                          Expanded(child: RegisterUser()),
                        ],
                      ) 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}