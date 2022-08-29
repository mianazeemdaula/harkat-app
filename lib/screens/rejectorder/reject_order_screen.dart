import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RejectOrderScreen extends StatefulWidget {
  final String orderId;

  const RejectOrderScreen({Key key, this.orderId}) : super(key: key);
  @override
  _RejectOrderScreenState createState() => _RejectOrderScreenState();
}

class _RejectOrderScreenState extends State<RejectOrderScreen> {
  bool _isUiBusy = false;
  List<String> _rejectStatusList = [
    "not_working".tr,
    "run_of_gas".tr,
    "accident".tr,
    "mechanic".tr,
    "issue".tr,
    "out_of_services".tr,
    "already_booked".tr,
  ];

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isUiBusy,
      child: Column(
        children: [
          // SizedBox(height: 10),
          // Container(
          //   height: SizeConfig.screenHeight * 0.1,
          //   decoration: BoxDecoration(
          //     color: kPrimaryColor,
          //   ),
          //   child: Center(
          //     child: Text(
          //       "Are you confirm?",
          //       style: Theme.of(context).textTheme.headline6,
          //     ),
          //   ),
          // ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${_rejectStatusList[index]}".tr),
                  onTap: () {
                    try {
                      setState(() {
                        _isUiBusy = true;
                      });
                      String uid = FirebaseAuth.instance.currentUser.uid;
                      FirebaseFirestore.instance
                          .collection("orders")
                          .doc(widget.orderId)
                          .update({
                        'notifications': {
                          '$uid': {
                            'status': 'cancel',
                            'reason': _rejectStatusList[index],
                          }
                        },
                      });
                      setState(() {
                        _isUiBusy = false;
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      Get.snackbar("Error!", "$e",
                          backgroundColor: kPrimaryColor.withOpacity(0.5),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _rejectStatusList.length,
            ),
          )
        ],
      ),
    );
  }
}
