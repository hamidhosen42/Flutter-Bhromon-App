// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static const routeName = '/reset-password';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  // !------------email textfield-------------
  TextEditingController _emailController = TextEditingController();

  bool loading = false;
  final auth = FirebaseAuth.instance;

  // !----------- email validation----------
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 30.0,
              color: const Color(0xFF21899C),
              letterSpacing: 2.000000061035156,
            ),
            children: const [
              TextSpan(
                text: 'RESET',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'PAGE',
                style: TextStyle(
                  color: Color(0xFFFE9879),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),

            // !-----------email text field--------------
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black45,
                    ),
                    hintText: "Enter your email",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFFABB3BB),
                      height: 1.0,
                    ),
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Email';
                    } else if (!isEmailValid(value)) {
                      return 'Please enter a valid Email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xFF21899C),
                ),
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = false;
                      });
                      auth
                          .sendPasswordResetEmail(email: _emailController.text)
                          .then((value) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            message:
                                "We have sent you email to recover password, please check email",
                          ),
                        );
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = true;
                        });
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: error.toString(),
                          ),
                        );
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'If you need to reset your password, please follow the steps below:\n1. Enter your email address associated with your account.\n2. Check your email for a password reset link. Make sure to check your spam folder if you dont see it in your inbox.\n3. Click on the password reset link and follow the instructions to create a new password.\n4. Once you have created a new password, you should be able to log in to your account with your new password.',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
