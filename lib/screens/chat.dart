import 'package:educa/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chat',
          style: GoogleFonts.balooDa(
            fontSize: 25,
            color: kAppColor,
          ),
        ),
      ),
    );
  }
}
