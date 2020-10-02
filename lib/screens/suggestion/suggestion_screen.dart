import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SuggestionScreen extends StatefulWidget {
  // UI Variables
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  // UI variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  int _selectedType = 0;
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
                    "suggestion_page_heading".tr(),
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getUiWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "suggestion_page_description".tr(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getUiHeight(20)),
                  Text(
                    "suggestion_type_lbl".tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: getUiHeight(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildOption("suggestion_suggestion".tr(), 0),
                      SizedBox(width: getUiWidth(10)),
                      buildOption("suggestion_complaint".tr(), 1),
                    ],
                  ),
                  SizedBox(height: getUiHeight(20)),
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: "suggestion_description_lbl".tr(),
                            hintText: "suggestion_description_placeholder".tr(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Description can't be empty";
                            else if (value.length < 20)
                              return "Minimum 20 character requied";
                            return null;
                          },
                        ),
                        SizedBox(height: getUiHeight(20)),
                        DefaultButton(
                          text: "suggestion_btn".tr(),
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              try {} catch (e) {
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

  Widget buildOption(String lablel, int type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedType == type ? kPrimaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(
            getUiWidth(50),
          ),
        ),
        child: Center(
          child: Text(
            "$lablel",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white),
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
