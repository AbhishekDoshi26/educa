import 'package:educa/constants.dart';
import 'package:educa/models/response_status_model.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  bool isButtonPressed = false;
  AuthProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AuthProvider>(context);
    super.didChangeDependencies();
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
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              AppPageTitles.kForgotPassword,
              style: GoogleFonts.balooDa(
                fontSize: 25,
                color: AppColors.kAppColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                AppStrings.kForgotPasswordPageHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                height: 60.0,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kAppColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18.0),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: HintText.kEmailAddressHint,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            createButton(context),
          ],
        ),
      ),
    );
  }

  Widget createButton(BuildContext context) {
    return isButtonPressed
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.kAppColor,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: AppColors.kAppColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            width: MediaQuery.of(context).size.width / 1.15,
            child: ElevatedButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.kAppColor)),
              onPressed: () => forgotPassword(),
              child: Text(
                ButtonText.kContinue,
                style: GoogleFonts.balooDa(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  void forgotPassword() async {
    setState(() {
      isButtonPressed = true;
    });
    ResponseStatusModel _responseStatusModel =
        await _provider.forgotPassword(_emailController.text);
    _emailController.clear();
    if (_responseStatusModel.isSuccess) {
      Fluttertoast.showToast(
        msg: _responseStatusModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } else {
      setState(() {
        isButtonPressed = false;
      });
      Fluttertoast.showToast(
        msg: _responseStatusModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
