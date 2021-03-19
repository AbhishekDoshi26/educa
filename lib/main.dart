import 'package:educa/constants.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:educa/providers/video_provider.dart';
import 'package:educa/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //AuthProvider is used in Login, Create Account, Forgot Password and Profile Page
        //VideoProvider is used in Home Page.
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => VideoProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.kAppTitle,
        home: SplashScreen(),
      ),
    );
  }
}
