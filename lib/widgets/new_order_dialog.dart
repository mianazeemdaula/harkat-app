import 'package:cached_network_image/cached_network_image.dart';
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
          Row(
            children: [
              SizedBox(
                width: getUiWidth(60),
                height: getUiWidth(60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(250),
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: "https://randomuser.me/api/portraits/men/97.jpg",
                  ),
                ),
              ),
              SizedBox(width: getUiWidth(20)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "new_order".tr,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      "${notification.addressFrom}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_downward,
                          size: getUiWidth(12),
                        ),
                      ),
                    ),
                    Text(
                      "${notification.addressTo}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
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
                Get.to(PickDropMapScreen(
                  orderId: notification.orderId,
                ));
                Get.snackbar(
                    "Success", "Order Assigned to you please deliver ASAP",
                    backgroundColor: Colors.green.withOpacity(0.5));
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
                    fullscreenDialog: true);
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
