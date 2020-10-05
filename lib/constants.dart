import 'package:flutter/material.dart';
import 'package:harkat_app/size_config.dart';

// Colros = 011627, FDFFFC, 2EC4B6, E71D36, FF9F1C
//

const kPrimaryColor = Color(0xFFb83b5e);
const kSecondaryColor = Color(0xFFf08a5d);
const kPrimaryLightColor = Color(0xFFFF9F1C);
const kMapRoutePickupColor = Color(0xFFf08a5d);
const kTextColor = Color(0xFF6a2c70);

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
