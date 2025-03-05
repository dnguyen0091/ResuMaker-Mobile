import 'package:flutter/material.dart';

import 'Pages/home.dart';

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
          seedColor: const Color.fromARGB(255, 223, 223, 223),
        ),
      ),
      // Define routes and set the initial route
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // HomeScreen from home.dart
        '/second': (context) => const SecondScreen(), // Example additional page
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