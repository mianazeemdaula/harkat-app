import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/theme.dart';
import 'package:harkat_app/widgets/default_button.dart';
import 'package:get/get.dart';

class SubmitMoneyScreen extends StatefulWidget {
  @override
  _SubmitMoneyScreenState createState() => _SubmitMoneyScreenState();
}

class _SubmitMoneyScreenState extends State<SubmitMoneyScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('submit_money_screen_appbar'.tr),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(getUiWidth(10)),
            color: kPrimaryColor.withOpacity(0.2),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'amount',
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      // labelText: 'submit_money_screen_amount_field_label'.tr,
                    ),
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: 'date',
                    lastDate: DateTime.now(),
                    decoration: InputDecoration(
                      hintText: "Select Date",
                      // labelText: 'submit_money_screen_date_field_label'.tr,
                    ),
                  ),
                  SizedBox(height: 10),
                  DefaultButton(
                    text: 'submit_money_screen_submit_btn'.tr,
                    press: () async {
                      try {
                        if (_formKey.currentState.saveAndValidate()) {
                          Map<String, dynamic> _data =
                              _formKey.currentState.value;
                          _data['driver_id'] =
                              FirebaseAuth.instance.currentUser.uid;
                          _data['approved'] = false;
                          await kcashDb.doc().set(_data);
                          kSuccessSnakbar(
                              'submit_money_screen_submit_success'.tr);
                          _formKey.currentState.fields.clear();
                        }
                      } catch (e) {
                        kErrorSnakbar('$e');
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Text(
              "History",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: kPrimaryColor,
                  ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: kcashDb
                  .where('driver_id',
                      isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(snapshot.data.docs[index].data()['approved']
                          ? Icons.check_circle_outline
                          : Icons.pending),
                      title: Text(
                        "${snapshot.data.docs[index].data()['date'].toDate().toString().substring(0, 19)}",
                      ),
                      trailing: Text(
                          "${snapshot.data.docs[index].data()['amount']}EAD"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
