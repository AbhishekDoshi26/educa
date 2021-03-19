import 'dart:io';

class UpdateProfileModel {
  String fullName;
  String email;
  File profilePic;
  UpdateProfileModel({this.email, this.fullName, this.profilePic});
}
