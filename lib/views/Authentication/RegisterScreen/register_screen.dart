// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_element, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../controllers/text_field_controller.dart';
import '../../../db/auth.dart';
import '../../../route/route.dart';
import '../../../styles/style.dart';
import '../../../widgets/violetButton.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // !--------------textfield------------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();

  // !-------------------auth controller----------------
  final authController = Get.put(AuthController());
  final _controller = Get.put(TextFieldController());

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  // !------------------validation----------------
  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  bool _validatePhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty && phoneNumber.length >= 11;
  }

  // bool _validateAddress(String address) {
  //   return address.isNotEmpty && address.isNotEmpty;
  // }

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox("", "");
            setState(() => isAlertSet = true);
          }
        },
      );
  final List<String> items = [
    'Barishal',
    'Chattogram',
    'Dhaka',
    'Khulna',
    'Rajshahi',
    'Rangpur',
    'Mymensingh',
    'Sylhet',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Container(
                  // color: Colors.red,
                  width: double.infinity,
                  height: 200.h,
                  child: Image.asset(
                    "assets/logo/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 30.sp,
                      color: const Color(0xFF21899C),
                      letterSpacing: 2.000000061035156,
                    ),
                    children: const [
                      TextSpan(
                        text: 'SIGNUP',
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
                Text(
                  'Let’s signup for explore continues',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    color: const Color(0xFF969AA8),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                // !----------------------Name Field------------------------
                TextFormField(
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      AppStyle().textFieldDecoration("Full Name", Icons.person),
                ),
                SizedBox(
                  height: 15.h,
                ),

                // !----------------------Email Field------------------------
                TextFormField(
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppStyle()
                      .textFieldDecoration("Enter your email", Icons.mail),
                ),
                SizedBox(
                  height: 15.h,
                ),

                // !----------------------Password Field------------------------
                Obx(() {
                  return TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
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
                        Icons.lock_open,
                        color: Colors.black45,
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: const Color(0xFFABB3BB),
                        height: 1.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _controller.isPasswordHiden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black45,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.isPasswordHiden.value =
                                !_controller.isPasswordHiden.value;
                          });
                        },
                      ),
                    ),
                    obscureText: _controller.isPasswordHiden.value,
                    validator: (value) {
                      if (!_validatePassword(value ?? '')) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  );
                }),
                SizedBox(
                  height: 15.h,
                ),

                Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    // Background color of the container
                    border: Border.all(
                      // Border properties
                      color: Colors.black, // Border color
                      width: 1, // Border width
                    ),
                    borderRadius: BorderRadius.circular(
                        10), // Border radius to make it rounded
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Bangladesh District',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        height: 40,
                        width: double.infinity,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 40.h,
                      ),
                    ),
                  ),
                ),

                // !----------------------Address Field------------------------
                // TextFormField(
                //   style: GoogleFonts.inter(
                //     fontSize: 18.0,
                //     color: const Color(0xFF151624),
                //   ),
                //   controller: _addressController,
                //   keyboardType: TextInputType.text,
                //   decoration: AppStyle().textFieldDecoration(
                //       "Enter your address", Icons.location_city_rounded),
                //   validator: (value) {
                //     if (!_validateAddress(value ?? '')) {
                //       return 'Address is required';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(
                //   height: 10.h,
                // ),
                // Text(
                //   'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(color: Colors.black45),
                // ),
                SizedBox(
                  height: 20.h,
                ),

                // !----------------------Create Buttom------------------------
                Obx(() {
                  return VioletButton(
                    isLoading: authController.isLoading.value,
                    title: 'Create Account',
                    onAction: () async {
                      if (_nameController.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: "Name is required",
                          ),
                        );
                        return;
                      }

                      if (_emailController.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: "Email is required",
                          ),
                        );
                        return;
                      }

                      if (_passwordController.text.isEmpty) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: "Password is required",
                          ),
                        );
                        return;
                      }
                      // if (_addressController.text.isEmpty) {
                      //   Get.snackbar('Error', 'Address is required');
                      //   return;
                      // }

                      authController.isLoading(true);

                      await authController.registration(
                        context: context,
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        address: selectedValue.toString(),
                        image: "",
                      );
                      authController.isLoading(false);
                    },
                  );
                }),
                SizedBox(height: 10.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                          flex: 2,
                          child: Divider(
                            color: Colors.black,
                          )),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Don’t Create Account?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: const Color(0xFF969AA8),
                            fontWeight: FontWeight.w500,
                            height: 1.67,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Divider(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Center(child: signInGoogleFacebookButton()),
                SizedBox(height: 10.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already an account? ",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                            text: "Sign In Here",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFFFF7248),
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(signIn)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signInGoogleFacebookButton() {
    return InkWell(
      onTap: () {
        var obj = authController;
        obj.signInWithGoogle(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: 150.w,
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.string(
              '<svg viewBox="-3.0 0.0 22.92 22.92" ><path transform="translate(-3.0, 0.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-1.68, 0.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-1.74, 13.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(8.46, 9.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
              width: 22.92,
              height: 22.92,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              'Google',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  showDialogBox(String title, String message) => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}