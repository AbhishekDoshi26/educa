import 'dart:io';

import 'package:educa/constants.dart';
import 'package:educa/models/update_profile_model.dart';
import 'package:educa/models/user_model.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:educa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  ProfilePage({this.email});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Image _profile;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  File profileImage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool isProfilePicUpdated = false;
  bool isButtonPressed = false;
  AuthProvider _authProvider;
  UserModel _userModel;
  bool isInitial = true;
  bool isResetClicked = false;

  @override
  void initState() {
    super.initState();
  }

  void getInitialData() async {
    if (mounted && isInitial) {
      setState(() {
        isInitial = false;
      });
      _authProvider = Provider.of<AuthProvider>(context);
      _userModel = await _authProvider.getUserData(widget.email);
      if (_authProvider.isSuccess) {
        if (_userModel.profileUrl == '')
          _profile = Image.asset(
            AppStrings.kDefaultProfilePicPath,
            color: Colors.grey.shade300,
            fit: BoxFit.fill,
          );
        else
          _profile = Image.network(_userModel.profileUrl);
        _nameController.text = _userModel.fullName;
        _emailController.text = _userModel.email;
      }
    }
  }

  @override
  void didChangeDependencies() {
    getInitialData();
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logOut,
          ),
        ],
      ),
      body: newAccount(context),
    );
  }

  Widget newAccount(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppPageTitles.kProfile,
              style: GoogleFonts.balooDa(
                color: AppColors.kAppColor,
                fontSize: 25.0,
              ),
            ),
            _userModel == null
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
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
                            hintText: HintText.kNameHint,
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            readOnly: false,
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
                            hintText: HintText.kEmailAddressHint,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.none,
                            readOnly: true,
                            onFieldSubmitted: (term) {
                              _emailFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                          isButtonPressed
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : createButton(context),
                          SizedBox(
                            height: 20.0,
                          ),
                          createPasswordResetButton(),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget createPasswordResetButton() {
    return isResetClicked
        ? Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: () => resetPassword(),
            child: Text(
              ButtonText.kResetPassword,
              style: GoogleFonts.balooDa(
                color: AppColors.kAppColor,
                fontSize: 15.0,
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
    TextCapitalization textCapitalization,
    bool readOnly,
  }) {
    return Padding(
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
              validator: (value) =>
                  value.isEmpty ? '$hintText cannot be blank' : null,
              textCapitalization: textCapitalization,
              readOnly: readOnly,
              textInputAction: textInputAction,
              autovalidateMode: _autovalidateMode,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: 18.0,
                color: readOnly ? Colors.grey : Colors.black,
              ),
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

  Widget showImageOptions() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor: AppColors.kAlertColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                ButtonText.kCaptureImage,
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
                ButtonText.kSelectFromGallery,
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

  void logOut() async {
    await _authProvider.logOut().then((value) {
      Fluttertoast.showToast(
        msg: _authProvider.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }

  void resetPassword() async {
    setState(() {
      isResetClicked = true;
    });
    await _authProvider.forgotPassword(_emailController.text);
    if (_authProvider.isSuccess) {
      Fluttertoast.showToast(
        msg: _authProvider.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: _authProvider.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
        profileImage = File(pickedFile.path);
        isProfilePicUpdated = true;
      } else {
        Fluttertoast.showToast(
          msg: Messages.kNoProfile,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  Widget createButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isProfilePicUpdated || _userModel.fullName != _nameController.text
                ? AppColors.kAppColor
                : Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width / 1.15,
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor:
              isProfilePicUpdated || _userModel.fullName != _nameController.text
                  ? MaterialStateProperty.all<Color>(AppColors.kAppColor)
                  : MaterialStateProperty.all<Color>(Colors.grey),
        ),
        onPressed:
            isProfilePicUpdated || _userModel.fullName != _nameController.text
                ? () {
                    onValidate();
                  }
                : null,
        child: Text(
          ButtonText.kUpdateProfile,
          style: GoogleFonts.balooDa(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void onValidate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isButtonPressed = true;
      });
      updateProfile();
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  void updateProfile() async {
    await _authProvider.updateProfile(
      isProfilePicUpdated,
      UpdateProfileModel(
        email: _emailController.text,
        fullName: _nameController.text,
        profilePic: profileImage,
      ),
      _userModel.profileUrl,
    );
    if (_authProvider.isSuccess) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: Messages.kProfileUpdated,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: _authProvider.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
                    color: AppColors.kAppColor,
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
