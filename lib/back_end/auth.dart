// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tour_application/admin/admin_home.dart';
import 'package:tour_application/route/route.dart';

import '../admin/nav_home.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  //for button loading indicator
  var isLoading = false.obs;

  Future<void> registration({
    required String name,
    required String email,
    required String password,
    required String number,
    required String address,
    required String image,
  }) async {
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          number.isNotEmpty &&
          address.isNotEmpty) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        Fluttertoast.showToast(
            msg: 'Please check your email for verification.');

        // No redirect to home screen yet
        // After saving user info, check email verification status
        bool isEmailVerified = userCredential.user!.emailVerified;

        UserModel userModel = UserModel(
          name: name,
          uid: userCredential.user!.uid,
          email: email,
          phoneNumber: number,
          address: address,
          image: image,
        );
        // Save user info in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());

        Get.toNamed(signIn);
      } else {
        Fluttertoast.showToast(msg: 'Please enter all the fields');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: 'Please enter a valid email.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  //for user login
  Future<void> userLogin(
    {required BuildContext context, required String email, required String password}) async {
  try {
    if (email.isNotEmpty && password.isNotEmpty) {
      // !------admin login------------
      if (email == "hamid@gmail.com" && password == "hamid@gmail") {
        Fluttertoast.showToast(msg: 'Admin Login Successful');
        // Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHome()));
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        var authCredential = userCredential.user;
        if (authCredential!.uid.isNotEmpty) {
          if (authCredential.emailVerified) {
            Fluttertoast.showToast(msg: 'Login Successful');
            Get.toNamed(home_screen);
          } else {
            Fluttertoast.showToast(
                msg: 'Email not verified. Please check your email and verify.');
          }
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong!');
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter all the fields");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error: $e');
  }
}


  //for logout
  signOut() async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: 'Log out');
    // Get.offAll(() => SignInScreen());
  }
}