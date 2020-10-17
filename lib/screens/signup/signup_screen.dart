import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
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

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<UserRepository>(context).isUiBusy,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: getUiWidth(20)),
              child: Column(
                children: [
                  SizedBox(
                    height: getUiWidth(250),
                    width: getUiHeight(250),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "signup_page_heading".tr,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "signup_page_description".tr,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getUiWidth(20)),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameTextController,
                          decoration: InputDecoration(
                            labelText: "signup_name_field".tr,
                            hintText: "signup_name_field_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter name';
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(15)),
                        TextFormField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            labelText: "email_lbl".tr,
                            hintText: "email_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kEmailNullError;
                            else if (!emailValidatorRegExp.hasMatch(value))
                              return kInvalidEmailError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(15)),
                        TextFormField(
                          controller: _reTypepasswordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "password_lbl".tr,
                            hintText: "password_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kPassNullError;
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "signup_retype_password_lbl".tr,
                            hintText: "signup_retype_password_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kPassNullError;
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _contactTextController,
                          decoration: InputDecoration(
                            labelText: "signup_contact_field".tr,
                            hintText: "signup_contact_place_holder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Please enter mobile #';
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _addressTextController,
                          decoration: InputDecoration(
                            labelText: "signup_address_field".tr,
                            hintText: "signup_address_placeholder".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kPassNullError;
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/signin');
                              },
                              child: Text(
                                "signup_already_account".tr,
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: getUiHeight(20)),
                        DefaultButton(
                          text: "signup_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                Provider.of<UserRepository>(context,
                                        listen: false)
                                    .signUp(
                                        _nameTextController.text,
                                        _contactTextController.text,
                                        _emailTextController.text,
                                        _passwordTextController.text,
                                        _addressTextController.text,
                                        context);
                              } catch (e) {
                                var snackbar = SnackBar(
                                  content: Text("$e"),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              }
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     Text(
      //       "Language",
      //       textAlign: TextAlign.center,
      //       style: Theme.of(context)
      //           .textTheme
      //           .subtitle1
      //           .copyWith(fontWeight: FontWeight.bold),
      //     ),
      //     Row(
      //       children: [
      //         OutlineButton(
      //           onPressed: () {
      //             context.locale = Locale('en', 'US');
      //           },
      //           child: Text("English"),
      //         ),
      //         OutlineButton(
      //           child: Text("عربی"),
      //           onPressed: () {
      //             context.locale = Locale('ar', 'AE');
      //           },
      //         )
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}
