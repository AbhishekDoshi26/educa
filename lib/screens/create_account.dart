import 'dart:io';

import 'package:educa/constants.dart';
import 'package:educa/screens/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Image _profile = Image.asset(
    'assets/profile_default.png',
    color: Colors.grey.shade300,
    height: 95.0,
  );

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  File profileImage;

  bool termsAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  void setProfileImage(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _profile = Image(
          fit: BoxFit.fill,
          image: FileImage(
            File(pickedFile.path),
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  Widget showImageOptions() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor: kAlertColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Capture Image',
                style: GoogleFonts.balooDa(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onTap: () => setProfileImage(ImageSource.camera),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Select From Gallery',
                style: GoogleFonts.balooDa(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.photo,
                color: Colors.white,
              ),
              onTap: () => setProfileImage(ImageSource.gallery),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 30.0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Create account',
              style: GoogleFonts.balooDa(
                color: kAppColor,
                fontSize: 25.0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    createProfilePicture(context),
                    SizedBox(
                      height: 50.0,
                    ),
                    createTextFormField(
                      controller: _nameController,
                      hintText: 'Name',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      focusNode: _nameFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        _nameFocus.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocus);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    createTextFormField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    createTextFormField(
                      controller: _passwordController,
                      hintText: 'Password',
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (term) {
                        _passwordFocus.unfocus();
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: termsAccepted,
                            activeColor: kAppColor,
                            onChanged: (value) {
                              setState(() {
                                termsAccepted = value;
                              });
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  termsAccepted = !termsAccepted;
                                });
                              },
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(
                                  text: 'By creating account, I agree to ',
                                  style: GoogleFonts.balooDa(
                                    color: Colors.grey.shade400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(color: kAppColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsAndConditions(),
                                            ),
                                          );
                                          FocusScope.of(context).unfocus();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    createButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container createButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: termsAccepted ? kAppColor : Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width / 1.15,
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: termsAccepted
              ? MaterialStateProperty.all<Color>(kAppColor)
              : MaterialStateProperty.all<Color>(Colors.grey),
        ),
        onPressed: termsAccepted ? () {} : null,
        child: Text(
          'Continue',
          style: GoogleFonts.balooDa(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget createTextFormField({
    String hintText,
    TextEditingController controller,
    TextInputType keyboardType,
    bool obscureText,
    FocusNode focusNode,
    Function(String term) onFieldSubmitted,
    TextInputAction textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(color: kAppColor),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextFormField(
              textInputAction: textInputAction,
              focusNode: focusNode,
              style: TextStyle(fontSize: 18.0),
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context, builder: (context) => showImageOptions()),
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: kAppColor,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _profile.image,
                radius: 60.0,
              ),
            ),
          ),
          Positioned.fill(
            top: 90.0,
            left: 90.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
