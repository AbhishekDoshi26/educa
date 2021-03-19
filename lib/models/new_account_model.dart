import 'dart:io';

class AccountModel {
  String fullName;
  String email;
  String password;
  File profilePic;
  AccountModel({this.email, this.fullName, this.password, this.profilePic});
}
