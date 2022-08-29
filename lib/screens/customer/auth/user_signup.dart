import 'dart:io';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // UI Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emirateIdTextController = TextEditingController();

  File _emirateId;

  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall:
            context.select<UserRepository, bool>((value) => value.isUiBusy),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: getUiWidth(20)),
              child: Column(
                children: [
                  SizedBox(
                    height: getUiHeight(30),
                  ),
                  Text(
                    "signup_page_heading".tr,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(30),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    scale: 6,
                  ),
                  SizedBox(
                    height: getUiHeight(20),
                  ),
                  SizedBox(height: getUiHeight(20)),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameTextController,
                          decoration: InputDecoration(
                            // labelText: "signup_name_field".tr,
                            hintText: "signup_name_field_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Please_Enter_your_name'.tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(15)),
                        TextFormField(
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            // labelText: "password_lbl".tr,
                            hintText: "password_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please_Enter_your_password".tr;
                            else if (value.length < 10)
                              return "please_enter_at_least_10_characters".tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            // labelText: "email_lbl".tr,
                            hintText: "email_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please_Enter_your_email".tr;
                            else if (!emailValidatorRegExp.hasMatch(value))
                              return "Please_Enter_Valid_Email".tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(15)),
                        TextFormField(
                          controller: _emirateIdTextController,
                          // obscureText: true,
                          decoration: InputDecoration(
                            // labelText: "signup_retype_password_lbl".tr,
                            hintText: "emirates_id_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "emirates_id_placeholder".tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        SizedBox(height: getUiHeight(20)),
                        DefaultButton(
                          text: "signup_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                // create signup method for user with require fields
                              } catch (e) {
                                var snackbar = SnackBar(
                                  content: Text("$e"),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: getUiHeight(25),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, '/signin');
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "signup_already_account".tr,
                                  style: TextStyle(
                                    color: kSecondaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "  " + "sign_in".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: kSecondaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: source,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        setState(() {
          _emirateId = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error!",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
