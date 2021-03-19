import 'dart:async';
import 'package:educa/constants.dart';
import 'package:educa/providers/video_provider.dart';
import 'package:educa/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AccountCreated extends StatefulWidget {
  final String email;
  final String fullName;

  const AccountCreated({this.email, this.fullName});
  @override
  _AccountCreatedState createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          child: ChangeNotifierProvider<VideoProvider>.value(
            value: VideoProvider(),
            child: HomePage(
              email: widget.email,
              name: widget.fullName,
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.tag_faces,
                size: 100,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                AppPageTitles.kAccountCreated,
                textAlign: TextAlign.center,
                style: GoogleFonts.balooDa(
                  color: AppColors.kAppColor,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(
                  AppStrings.kAccountCreatedPageHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
