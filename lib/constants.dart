import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/size_config.dart';

Map<int, Color> colorCodes = {
  50: Color.fromRGBO(184, 59, 94, .1),
  100: Color.fromRGBO(184, 59, 94, .2),
  200: Color.fromRGBO(184, 59, 94, .3),
  300: Color.fromRGBO(184, 59, 94, .4),
  400: Color.fromRGBO(184, 59, 94, .5),
  500: Color.fromRGBO(184, 59, 94, .6),
  600: Color.fromRGBO(184, 59, 94, .7),
  700: Color.fromRGBO(184, 59, 94, .8),
  800: Color.fromRGBO(184, 59, 94, .9),
  900: Color.fromRGBO(184, 59, 94, 1),
};
// Green color code: FF93cd48
MaterialColor appColor = MaterialColor(0xFF405EAB, colorCodes);

// Colros = 011627, FDFFFC, 2EC4B6, E71D36, FF9F1C
//

const kPrimaryColor = Color(0xFF405EAB);
const kSecondaryColor = Color(0xFF1E71FF);
const kPrimaryLightColor = Color(0xFFFF9F1C);
const kMapRoutePickupColor = Color(0xFFf08a5d);
const kTextColor = Color(0xFF1E71FF);
const kGreenColor = Color(0xFF029B16);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getUiWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

// const
const String googleMapApi = "AIzaSyBE0ICU01Uo4vIKNYv90657DD1qqm7YQQg";

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp mobileValidatorRegExp =
    RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getUiWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getUiWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

CollectionReference kcashDb = FirebaseFirestore.instance.collection('cash');

kErrorSnakbar(error) {
  Get.snackbar(
    "Error!",
    "$error",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.withOpacity(0.5),
  );
}

kSuccessSnakbar(msg) {
  Get.snackbar(
    "Success!",
    "$msg",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.withOpacity(0.5),
  );
}
