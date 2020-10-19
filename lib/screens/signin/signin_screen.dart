import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
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
                  SizedBox(height: getUiHeight(10)),
                  SizedBox(
                    height: getUiWidth(250),
                    width: getUiHeight(250),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: getUiHeight(10)),
                  Text(
                    "login_page_heading".tr,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "login_page_description".tr,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getUiWidth(20)),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
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
                          controller: _passwordTextController,
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/resetpassword');
                              },
                              child: Text(
                                "forget_password".tr,
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: getUiHeight(20)),
                        DefaultButton(
                          text: "login_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                bool isAuthor =
                                    await Provider.of<UserRepository>(context,
                                            listen: false)
                                        .signIn(_emailTextController.text,
                                            _passwordTextController.text);

                                if (!isAuthor) {
                                  var snackbar = SnackBar(
                                    content:
                                        Text("email_password_not_match".tr),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackbar);
                                }
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
                        SizedBox(height: getUiHeight(10)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Language",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              OutlineButton(
                onPressed: () {
                  Get.updateLocale(Locale('en', 'US'));
                },
                child: Text("English"),
              ),
              OutlineButton(
                child: Text("عربی"),
                onPressed: () {
                  Get.updateLocale(Locale('ar', 'AE'));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
