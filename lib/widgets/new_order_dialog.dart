import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/model/new_order_notification.dart';
import 'package:harkat_app/screens/pick_drop_order_map/pick_drop_order_map_screen.dart';
import 'package:harkat_app/screens/rejectorder/reject_order_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';

class NewOrderDialog extends StatelessWidget {
  const NewOrderDialog({
    Key key,
    this.notification,
  }) : super(key: key);

  final NewOrderNotification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getUiWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "new_order".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              Text(
                "${notification.addressFrom}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 12),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_downward,
                    size: getUiWidth(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${notification.addressTo}",
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("orders")
                    .doc(notification.orderId)
                    .update({
                  'status': 'assigned',
                  'driver': FirebaseAuth.instance.currentUser.uid
                });
                Navigator.pop(context);
                Get.to(() => PickDropMapScreen(
                      orderId: notification.orderId,
                    ));
                Get.snackbar(
                  "Success",
                  "Order Assigned to you please deliver ASAP",
                  backgroundColor: Colors.green.withOpacity(0.5),
                );
              },
              color: kPrimaryColor,
              elevation: 0.0,
              child: Text(
                "acceptbtn".tr,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (_) => RejectOrderScreen(
                    orderId: notification.orderId,
                  ),
                  fullscreenDialog: true,
                );
                Navigator.pop(context);
                Navigator.push(context, route);
              },
              elevation: 0.0,
              color: Colors.transparent,
              child: Text("rejectbtn".tr),
            ),
          )
        ],
      ),
    );
  }
}
