import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

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

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
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
                  "Welcome Back",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: getUiWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailTextController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
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
                          labelText: "Password",
                          hintText: "Enter your password",
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
                            onTap: () => Navigator.pushNamed(context, 'forget'),
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: getUiHeight(20)),
                      DefaultButton(
                        text: "Continue",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              bool isAuthor = await Provider.of<UserRepository>(
                                      context,
                                      listen: false)
                                  .signIn(_emailTextController.text,
                                      _passwordTextController.text);
                              if (!isAuthor) {
                                var snackbar = SnackBar(
                                  content: Text("Email or password not mached"),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              }
                            } catch (e) {
                              var snackbar = SnackBar(
                                content: Text("$e"),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
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
    );
  }
}
