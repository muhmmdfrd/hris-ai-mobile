import 'package:flutter/material.dart';
import 'package:hris_ai/modules/auth/auth_screen.dart';
import 'package:hris_ai/modules/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/home',
      routes: {'/auth': (context) => const AuthScreen(), '/home': (context) => const HomeScreen()},
    );
  }
}
