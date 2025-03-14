import 'package:flutter/material.dart';

import '../Forms/login.dart';
import '../Forms/register.dart';

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
      resizeToAvoidBottomInset:true, 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            
            // Animated custom tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25.0),
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
                          color: Colors.blue,
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
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
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
                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:Column(
                      children:[
                        const SizedBox(height: 50,),
                        Expanded(child:LoginUser()),
                      ]
                    ) 
                  ),
                  
                  // Register form
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:Column(
                      children: [
                        const SizedBox(height: 50,),
                        Expanded(child:RegisterUser()),
                      ],
                    ) 
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