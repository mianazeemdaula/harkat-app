import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    // fontFamily: "Sfui",
    appBarTheme: appBarTheme(),
    primaryColor: appColor,
    accentColor: kSecondaryColor,
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide.none,

    // borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    fillColor: Colors.grey.withOpacity(0.3),
    hintStyle: TextStyle(color: Colors.grey),
    filled: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    // enabledBorder: outlineInputBorder,
    // focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kPrimaryColor,
    centerTitle: true,
    // elevation: 0,
    // brightness: Brightness.light,
    // iconTheme: IconThemeData(color: Colors.black),
    // textTheme: TextTheme(
    //   headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    // ),
  );
}

kErrorSnakBar(String error, {String title}) {
  Get.snackbar(
    title ?? 'Error!',
    "$error",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
  );
}

kSuccessSnakBar(String msg, {String title}) {
  Get.snackbar(
    title ?? 'Success!',
    "$msg",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
  );
}
