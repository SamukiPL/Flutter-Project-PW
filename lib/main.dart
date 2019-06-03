import 'package:flutter/material.dart';
import 'package:pw_project/windows/splash/splash_window.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projekt PW',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent
      ),
      home: SplashWindow(),
    );
  }
}
