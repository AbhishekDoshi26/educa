import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthProvider extends ChangeNotifier {
  bool isSuccess;
  String message;

  void login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isSuccess = true;
      message = 'Login Successful';
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
        print(message);
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
        print(message);
      }
    }
    notifyListeners();
  }

  void uploadData(
      String fullName, String email, String password, File file) async {
    String downloadURL;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${file.path}.png')
          .putFile(file)
          .then((value) async {
        downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref('uploads/${file.path}.png')
            .getDownloadURL();
        users
            .add({
              'full_name': fullName,
              'email': email,
              'profile_pic': downloadURL,
            })
            .then((value) => register(email, password))
            .catchError((error) => print("Failed to add user: $error"));
      });
    } on FirebaseException catch (e) {
      isSuccess = false;
      message = 'Server Error, Please try again later.';
    }
  }

  void register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      message = 'User Registered Successfully';
      isSuccess = true;
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}