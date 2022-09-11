import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:get/get.dart';

class SuggestionCreateScreen extends StatefulWidget {
  // UI Variables
  @override
  _SuggestionCreateScreenState createState() => _SuggestionCreateScreenState();
}

class _SuggestionCreateScreenState extends State<SuggestionCreateScreen> {
  // UI variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DropdownMenuItem> _types = [];
  bool _isUiBusy = false;

  Future<void> getTypes(String type) async {
    QuerySnapshot<Map<String, dynamic>> _data = await _firestore
        .collection('complaint_suggestion_types')
        .where('type', isEqualTo: type)
        .get();
    _data.docs.forEach((element) {
      _types.add(
        DropdownMenuItem(
          child: Text(element.data()['title']),
          value: element.data()['title'].toString().toLowerCase(),
        ),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("suggestion_page_heading".tr),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isUiBusy,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: getUiWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getUiHeight(25)),
                Text(
                  "suggestion_page_heading".tr,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: getUiWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "suggestion_page_description".tr,
                  style: TextStyle(color: kSecondaryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getUiHeight(20)),
                Text(
                  "suggestion_type_lbl".tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: getUiHeight(20)),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                        name: 'type',
                        items: [
                          DropdownMenuItem(
                            child: Text('Complaint'),
                            value: 'complaint',
                          ),
                          DropdownMenuItem(
                            child: Text('Suggestion'),
                            value: 'suggestion',
                          )
                        ],
                        onChanged: (value) => getTypes(value),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      SizedBox(height: getUiHeight(20)),
                      FormBuilderDropdown(
                        name: 'category',
                        items: _types,
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      SizedBox(height: getUiHeight(20)),
                      FormBuilderTextField(
                        name: 'content',
                        maxLines: 6,
                        decoration: InputDecoration(
                          // labelText: "suggestion_description_lbl".tr,
                          hintText: "suggestion_description_placeholder".tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(20),
                        ]),
                      ),
                      SizedBox(height: getUiHeight(100)),
                      DefaultButton(
                        text: "suggestion_btn".tr,
                        press: () async {
                          if (_formKey.currentState.saveAndValidate()) {
                            await submitForm();
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

  Future<void> submitForm() async {
    try {
      setState(() {
        _isUiBusy = true;
      });
      User _user = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> _data = _formKey.currentState.value;
      _data['user'] = _user.uid;
      _data['name'] = _user.displayName;
      _data['date'] = FieldValue.serverTimestamp();
      _data['status'] = 'open';
      await _firestore.collection('complaint_suggestion').doc().set(_data);
      Get.snackbar('Success!', _data['type'] + " added successfully",
          snackPosition: SnackPosition.BOTTOM);
      _formKey.currentState.reset();
      setState(() {
        _isUiBusy = false;
      });
    } catch (e) {
      setState(() {
        _isUiBusy = false;
      });
      Get.snackbar(
        'Error!',
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.5),
      );
    }
  }
}
