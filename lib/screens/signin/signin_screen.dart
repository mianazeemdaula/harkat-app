import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/signup/signup_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // UI Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall:
              context.select<UserRepository, bool>((value) => value.isUiBusy),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: getUiWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: getUiHeight(30)),
                  // SizedBox(
                  //   height: getUiWidth(250),
                  //   width: getUiHeight(250),
                  //   child: Image.asset(
                  //     "assets/images/logo.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  SizedBox(height: getUiHeight(10)),
                  Text(
                    "login_page_heading".tr,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getUiHeight(30)),
                  Text(
                    "login_page_description".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kSecondaryColor),
                  ),
                  SizedBox(height: getUiWidth(100)),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
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
                            else if (value.length < 6)
                              return "password_is_too_short".tr;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/resetpassword');
                              },
                              child: Text(
                                "forget_password".tr,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getUiHeight(150)),
                        DefaultButton(
                          text: "login_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                await Provider.of<UserRepository>(context,
                                        listen: false)
                                    .signIn(_emailTextController.text,
                                        _passwordTextController.text);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             VehicleTypeScreen()));
                              } catch (e) {
                                Get.snackbar(
                                  "Error!",
                                  "$e",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(height: getUiHeight(10)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getUiHeight(25),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "have_no_acc".tr,
                          style: TextStyle(color: kSecondaryColor),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => SignUpScreen());
                            },
                          text: "  " + "sign_up".tr,
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
