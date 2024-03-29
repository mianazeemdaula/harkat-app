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
                    height: getUiWidth(200),
                    width: getUiHeight(200),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
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
                  SizedBox(height: getUiWidth(10)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text(
                          "signup_already_account".tr,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              decoration: TextDecoration.underline,
                              color: kPrimaryColor),
                        ),
                      )
                    ],
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
                            else if (value.length < 6)
                              return 'Please enter at least 10 characters';
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
                        // SizedBox(height: getUiHeight(10)),
                        // TextFormField(
                        //   controller: _addressTextController,
                        //   decoration: InputDecoration(
                        //     labelText: "signup_address_field".tr,
                        //     hintText: "signup_address_placeholder".tr,
                        //     floatingLabelBehavior: FloatingLabelBehavior.always,
                        //   ),
                        //   validator: (String value) {
                        //     if (value.isEmpty)
                        //       return kPassNullError;
                        //     else if (value.length < 6) return kShortPassError;
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(height: getUiHeight(10)),
                        // TextFormField(
                        //   controller: _addressTextController,
                        //   decoration: InputDecoration(
                        //     labelText: "signup_address_field".tr,
                        //     hintText: "signup_address_placeholder".tr,
                        //     floatingLabelBehavior: FloatingLabelBehavior.always,
                        //   ),
                        //   validator: (String value) {
                        //     if (value.isEmpty)
                        //       return kPassNullError;
                        //     else if (value.length < 6) return kShortPassError;
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(height: getUiHeight(10)),
                        // TextFormField(
                        //   controller: _addressTextController,
                        //   decoration: InputDecoration(
                        //     labelText: "signup_address_field".tr,
                        //     hintText: "signup_address_placeholder".tr,
                        //     floatingLabelBehavior: FloatingLabelBehavior.always,
                        //   ),
                        //   validator: (String value) {
                        //     if (value.isEmpty)
                        //       return kPassNullError;
                        //     else if (value.length < 6) return kShortPassError;
                        //     return null;
                        //   },
                        // ),
                        SizedBox(height: getUiHeight(10)),
                        TextFormField(
                          controller: _appartmentTextController,
                          decoration: InputDecoration(
                            labelText: "signup_apparment_no_field".tr,
                            hintText: "signup_apparment_no".tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) return 'signup_apparment_no'.tr;
                            return null;
                          },
                        ),
                        // SizedBox(height: getUiHeight(10)),
                        // TextFormField(
                        //   controller: _emirateIDTextController,
                        //   decoration: InputDecoration(
                        //     labelText: "signup_emirate_field".tr,
                        //     hintText: "signup_emirate_field_placeholder".tr,
                        //     floatingLabelBehavior: FloatingLabelBehavior.always,
                        //   ),
                        //   validator: (String value) {
                        //     if (value.isEmpty)
                        //       return "signup_emirate_field_empty".tr;
                        //     else if (value.length < 6)
                        //       return 'Please enter atleast 6 characters';
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(height: getUiHeight(10)),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Center(
                        //         child: _emirateId == null
                        //             ? Text("EMIRATE ID")
                        //             : Container(
                        //                 width: getUiWidth(120),
                        //                 height: getUiWidth(120),
                        //                 child: Image.file(
                        //                   _emirateId,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 10),
                        //     Column(
                        //       children: [
                        //         IconButton(
                        //           icon: Icon(Icons.camera_alt),
                        //           onPressed: () =>
                        //               pickImage(ImageSource.camera),
                        //         ),
                        //         IconButton(
                        //           icon: Icon(Icons.image),
                        //           onPressed: () =>
                        //               pickImage(ImageSource.gallery),
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ),
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
                            Text('I accept terms and conditions'),
                          ],
                        ),
                        DefaultButton(
                          text: "signup_btn".tr,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                if (!isTermsAccepted) {
                                  Get.snackbar(
                                    "Required",
                                    "Please Accept terms and conidtions",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                // if (_emirateId == null) {
                                //   Get.snackbar(
                                //     "Required",
                                //     "Please upload Emirate scanned ID",
                                //     snackPosition: SnackPosition.BOTTOM,
                                //   );
                                //   return;
                                // }
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
