import 'dart:async';
import 'package:educa/constants.dart';
import 'package:educa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          child: LoginScreen(),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppColor,
      body: Center(
        child: Text(
          'educa',
          style: GoogleFonts.balooDa(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
