import 'package:educa/constants.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:educa/screens/create_account.dart';
import 'package:educa/screens/forgot_password.dart';
import 'package:educa/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _passwordFocus = FocusNode();

  AuthProvider _provider;
  bool isButtonPressed = false;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AuthProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TextButton(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Create new account',
            style: GoogleFonts.balooDa(color: Colors.black54, fontSize: 15.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (BuildContext context) => AuthProvider(),
                  child: Register()),
            ),
          );
        },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'Sign in',
                style: GoogleFonts.balooDa(
                  fontSize: 25,
                  color: kAppColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: kAppColor),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              style: TextStyle(fontSize: 18.0),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: kAppColor),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              autofocus: false,
                              focusNode: _passwordFocus,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (term) {
                                _passwordFocus.unfocus();
                              },
                              style: TextStyle(fontSize: 18.0),
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                AuthProvider(),
                                            child: ForgotPassword(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 5.0),
                                      child: Text(
                                        'Forgot?',
                                        style: TextStyle(
                                          color: kAppColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      isButtonPressed
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: kAppColor,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: kAppColor,
                                border: Border.all(color: kAppColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width / 0.5,
                              child: TextButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    isButtonPressed = true;
                                  });
                                  await _provider.login(_emailController.text,
                                      _passwordController.text);
                                  _emailController.clear();
                                  _passwordController.clear();
                                  if (_provider.isSuccess) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                    Fluttertoast.showToast(
                                      msg: _provider.message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: kAlertColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    setState(() {
                                      isButtonPressed = false;
                                    });
                                    Fluttertoast.showToast(
                                      msg: _provider.message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.balooDa(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
