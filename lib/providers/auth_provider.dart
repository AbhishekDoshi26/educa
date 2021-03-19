import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educa/constants.dart';
import 'package:educa/models/new_account_model.dart';
import 'package:educa/models/update_profile_model.dart';
import 'package:educa/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthProvider extends ChangeNotifier {
  //Checks whether the operation was successfull or not
  bool isSuccess = false;

  //Gives message for success or failure
  String message = '';

  //Login Functionality
  Future<void> login(String email, String password) async {
    try {
      //Login with Email and Password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //If no exception is thrown, setting message and isSuccess.
      isSuccess = true;
      message = Messages.kLoginSuccess;
    } on FirebaseAuthException catch (e) {
      //If exception is thrown, isSuccess to false
      isSuccess = false;
      if (e.code == 'user-not-found') {
        //User not registered
        message = Messages.kNoUserFound;
      } else if (e.code == 'wrong-password') {
        //Wrong password entered
        message = Messages.kWrongPassword;
      }
      notifyListeners();
    }
    notifyListeners();
  }

  //Get User Data for profile and home screen
  Future<UserModel> getUserData(String email) async {
    try {
      //Collection Name: users, Document Name: email
      DocumentSnapshot data =
          await FirebaseFirestore.instance.collection("users").doc(email).get();
      isSuccess = true;
      notifyListeners();
      return UserModel(
        email: data.data()['email'].toString(),
        fullName: data.data()['full_name'].toString(),
        profileUrl: data.data()['profile_pic'].toString(),
      );
    } catch (e) {
      isSuccess = false;
      message = e.toString();
      notifyListeners();

      //Sending empty model if exception is thrown
      return UserModel(
        email: ' ',
        fullName: ' ',
        profileUrl: ' ',
      );
    }
  }

  //Update Profile Functionality
  Future<void> updateProfile(
      bool isProfilePicUpdated, UpdateProfileModel updateProfileModel) async {
    String downloadURL = '';
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    //If profile pic is updated, upload new profile pic with same name so it will get replaced
    //Then download the URL of it and update in firestore
    if (isProfilePicUpdated) {
      try {
        if (updateProfileModel.profilePic != null) {
          await firebase_storage.FirebaseStorage.instance
              .ref('profile/${updateProfileModel.email}.png')
              .putFile(updateProfileModel.profilePic)
              .then((value) async {
            downloadURL = await firebase_storage.FirebaseStorage.instance
                .ref('profile/${updateProfileModel.email}.png')
                .getDownloadURL();
            users.doc(updateProfileModel.email).set({
              'full_name': updateProfileModel.fullName,
              'email': updateProfileModel.email,
              'profile_pic': downloadURL,
            }).catchError((error) {
              isSuccess = false;
              notifyListeners();
            });
          });
        } else {
          users.doc(updateProfileModel.email).set({
            'full_name': updateProfileModel.fullName,
            'email': updateProfileModel.email,
            'profile_pic': downloadURL,
          }).catchError((error) {
            isSuccess = false;
            notifyListeners();
          });
        }
      } on FirebaseException catch (e) {
        print(e);
        isSuccess = false;
        message = Messages.kServerError;
        notifyListeners();
      }
    }
    //If profile pic is not updated i.e. if only the name is updated, directly update data in firestore.
    else {
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile/${updateProfileModel.email}.png')
          .getDownloadURL();
      users.doc(updateProfileModel.email).set(
        {
          'full_name': updateProfileModel.fullName,
          'email': updateProfileModel.email,
          'profile_pic': downloadURL,
        },
      ).catchError((error) {
        isSuccess = false;
        message = Messages.kServerError;
        notifyListeners();
      });
    }
  }

  //Uploads data during create new account and then calls _register() method
  Future<void> uploadData({AccountModel accountModel}) async {
    String downloadURL = '';
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      if (accountModel.profilePic != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref('profile/${accountModel.email}.png')
            .putFile(accountModel.profilePic)
            .then((value) async {
          downloadURL = await firebase_storage.FirebaseStorage.instance
              .ref('profile/${accountModel.email}.png')
              .getDownloadURL();
          users
              .doc(accountModel.email)
              .set({
                'full_name': accountModel.fullName,
                'email': accountModel.email,
                'profile_pic': downloadURL,
              })
              .then((value) async =>
                  await _register(accountModel.email, accountModel.password))
              .catchError((error) {
                isSuccess = false;
                message = Messages.kServerError;
                notifyListeners();
              });
        });
      } else {
        users
            .doc(accountModel.email)
            .set({
              'full_name': accountModel.fullName,
              'email': accountModel.email,
              'profile_pic': downloadURL,
            })
            .then((value) async =>
                await _register(accountModel.email, accountModel.password))
            .catchError((error) {
              isSuccess = false;
              message = Messages.kServerError;
              notifyListeners();
            });
      }
    } on FirebaseException catch (e) {
      isSuccess = false;
      message = Messages.kServerError + e.toString();
      notifyListeners();
    }
  }

  //This method is called after the data is uploaded during create new account.
  Future<void> _register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      message = Messages.kRegistrationSuccess;
      isSuccess = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (e.code == 'weak-password') {
        message = Messages.kWeakPassword;
      } else if (e.code == 'email-already-in-use') {
        message = Messages.kAlreadyExists;
      }
      notifyListeners();
    } catch (e) {
      isSuccess = false;
      message = Messages.kServerError;
      notifyListeners();
    }
    notifyListeners();
  }

  //Method called on forgot password (in login screen) and reset password (in profile screen)
  //It sends a reset password link to the email id that the user enters (in forgot password)
  //Or it will send to the current logged in user (if clicked on reset password)
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      message = 'Password reset link sent to $email';
      isSuccess = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (e.code == 'user-not-found') {
        message = Messages.kNoUserFound;
        print(message);
      }
      notifyListeners();
    } catch (e) {
      print(e);
      isSuccess = false;
      message = Messages.kServerError;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      isSuccess = true;
      message = Messages.kLogOutSuccess;
      notifyListeners();
    } catch (e) {
      isSuccess = false;
      message = e.toString();
      notifyListeners();
    }
  }
}
