import 'package:flutter/material.dart';

import 'Forms/login.dart';
import 'Forms/register.dart';
import 'Pages/enter_user.dart';
import 'Pages/mainPage.dart';
import 'app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor,
        ),
      ),
      // Define routes and set the initial route
      initialRoute: '/',
      routes: {
        
        '/': (context) => MainPage(), 
        //'/': (context) => HomeScreen(), // HomeScreen from home.dart
        '/second': (context) => const SecondScreen(), // Example additional page
        '/enter_user': (context) => EnterUser(), // EnterUser from enter_user.dart
        '/login': (context) => LoginUser(), // EnterUser from enter_user.dart
        '/register': (context) => RegisterUser(), // EnterUser from enter_user.dartWW
        '/main': (context) => MainPage(), // MainPage from mainPage.dart
      },
    );
  }
}

// Example additional page to switch to
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: const Center(
        child: Text('Welcome to the second screen!'),
      ),
    );
  }
}