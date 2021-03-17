import 'package:educa/providers/auth_provider.dart';
import 'package:educa/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'educa',
      home: ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
          child: SplashScreen()),
    );
  }
}
