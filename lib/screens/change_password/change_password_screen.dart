import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // UI Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: Provider.of<UserRepository>(context).isUiBusy,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: getUiWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: getUiHeight(25)),
                  Text(
                    "changepassword_page_heading".tr(),
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "changepassword_page_description".tr(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "old_password_lbl".tr(),
                            hintText: "old_password_placeholder".tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kPassNullError;
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(20)),
                        TextFormField(
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "new_password_lbl".tr(),
                            hintText: "new_password_placeholder".tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return kPassNullError;
                            else if (value.length < 6) return kShortPassError;
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(20)),
                        DefaultButton(
                          text: "changepassword_btn".tr(),
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                bool isPasswordChange =
                                    await Provider.of<UserRepository>(context,
                                            listen: false)
                                        .updatePassword(
                                            _oldPasswordController.text,
                                            _passwordTextController.text);

                                if (isPasswordChange) {
                                  showSnakBar("Password changed successfully!");
                                } else {
                                  showSnakBar("Password not matched");
                                }
                              } catch (e) {
                                showSnakBar("$e");
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
    );
  }

  showSnakBar(String msg) {
    var snackbar = SnackBar(
      content: Text("$msg".tr()),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
