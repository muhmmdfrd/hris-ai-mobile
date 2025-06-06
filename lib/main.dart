import 'package:flutter/material.dart';
import 'package:hris_ai/http/api_client.dart';
import 'package:hris_ai/modules/maps/maps_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hris_ai/modules/auth/auth_screen.dart';
import 'package:hris_ai/modules/feedback/feedback_screen.dart';
import 'package:hris_ai/modules/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(initialRoute: token == null ? '/auth' : '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: initialRoute,
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/maps': (context) => const MapsScreen(title: ''),
      },
    );
  }
}
