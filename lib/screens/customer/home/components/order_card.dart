import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/customer/track_order/track_order_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> order;

  const OrderCard({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(getUiWidth(5)),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: CachedNetworkImageProvider(
                      "https://www.w3schools.com/w3images/avatar6.png"),
                ),
              ),
              Expanded(
                flex: 1,
                child: buildContactRow(
                  context,
                  order.data()['sender_name'],
                  order.data()['sender_contact'],
                ),
              ),
              SizedBox(width: 55),
              Expanded(
                flex: 2,
                child: buildContactRow(
                  context,
                  order.data()['receiver_name'],
                  order.data()['receiver_contact'],
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "${DateTime.parse(order.data()['date'].toDate().toString())}",
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodyText2
          //           .copyWith(fontSize: getUiWidth(10)),
          //     ),
          //     Text(
          //       "${order.data()['status']}",
          //       style: Theme.of(context).textTheme.bodyText2,
          //     ),
          //   ],
          // ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AddressCard(
                    title: "From",
                    address: "${order.data()['address_from']}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [Icon(Icons.arrow_forward_ios)],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AddressCard(
                    title: "To",
                    address: "${order.data()['address_to']}",
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              order.data()['status'] != 'complete'
                  ? Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kGreenColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                            builder: (_) => TrackOrderScreen(orderId: order.id),
                          );
                          Navigator.push(context, route);
                        },
                        child: Text(
                          "track".tr,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("complete".tr),
                    ),
              SizedBox(width: 15),
              order.data()['status'] != 'complete'
                  ? Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          dialog(context);
                          // showAboutDialog(context: context);
                        },
                        child: Text("reject".tr),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ],
      ),
    );
  }

  Row buildContactRow(BuildContext context, String name, String contact) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$name",
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
            ),
            Row(
              children: [
                Text(
                  "$contact",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 12),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({
    Key key,
    this.title,
    this.address,
  }) : super(key: key);
  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$title",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          "$address",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

dialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('note'.tr),
            content: Text('Are_You_Really_Reject_Order'.tr),
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: Icon(Icons.check)),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ));
}
