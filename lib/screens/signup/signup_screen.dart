import 'dart:io';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/terms_and_conditions/terms_screen.dart';
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
  final _reTypepasswordTextController = TextEditingController();
  final _contactTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _emirateIDTextController = TextEditingController();
  final _appartmentTextController = TextEditingController();

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
                          controller: _reTypepasswordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            // labelText: "signup_retype_password_lbl".tr,
                            hintText: "signup_retype_password_placeholder".tr,
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
                          controller: _contactTextController,
                          decoration: InputDecoration(
                            // labelText: "signup_contact_field".tr,
                            hintText: "signup_contact_place_holder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'enter_mobile_number'.tr;
                            else if (value.length < 6)
                              return 'please_enter_at_least_10_characters'.tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _addressTextController,
                          decoration: InputDecoration(
                            // labelText: "signup_address_field".tr,
                            hintText: "signup_address_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "signup_address_placeholder".tr;
                            else if (value.length < 6)
                              return "address_is_too_short".tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _appartmentTextController,
                          decoration: InputDecoration(
                            // labelText: "signup_apparment_no_field".tr,
                            hintText: "signup_apparment_no".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) return 'signup_apparment_no'.tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        Row(
                          children: [
                            Checkbox(
                              value: isTermsAccepted,
                              onChanged: (bool value) async {
                                Route route = MaterialPageRoute(
                                  builder: (_) => TermsScreen(),
                                  fullscreenDialog: true,
                                );
                                var isAccept =
                                    await Navigator.push(context, route);
                                if (isAccept is bool && isAccept) {
                                  setState(() {
                                    isTermsAccepted = value;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              'I_accept_terms_and_conditions'.tr,
                              style: TextStyle(color: kSecondaryColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getUiHeight(20),
                        ),
                        DefaultButton(
                          text: "signup_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                if (!isTermsAccepted) {
                                  Get.snackbar(
                                    "required".tr,
                                    "I_accept_terms_and_conditions".tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                Provider.of<UserRepository>(context,
                                        listen: false)
                                    .signUp(
                                  _nameTextController.text,
                                  _contactTextController.text,
                                  _emailTextController.text,
                                  _passwordTextController.text,
                                  _addressTextController.text,
                                  _emirateIDTextController.text,
                                  _appartmentTextController.text,
                                  context,
                                  _emirateId,
                                );
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
