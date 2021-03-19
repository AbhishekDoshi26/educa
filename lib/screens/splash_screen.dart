import 'dart:async';
import 'package:educa/constants.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:educa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //This is done so that if previously the user has rotated the screen for video,
    //the entire app won't be havin that orientation. (For the safer side)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Timer(
      Duration(seconds: 1),
      () => Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(),
            child: LoginScreen(),
          ),
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppColor,
      body: Center(
        child: Text(
          AppStrings.kAppTitle,
          style: GoogleFonts.balooDa(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
