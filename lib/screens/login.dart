import 'package:educa/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TextButton(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Create new account',
            style: TextStyle(color: Colors.black, fontSize: 15.0),
          ),
        ),
        onPressed: () {},
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
                style: TextStyle(
                  fontSize: 25,
                  color: kAppColor,
                  fontWeight: FontWeight.bold,
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
                              style: TextStyle(fontSize: 18.0),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
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
                      Container(
                        decoration: BoxDecoration(
                          color: kAppColor,
                          border: Border.all(color: kAppColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 0.5,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Continue',
                            style: TextStyle(
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
