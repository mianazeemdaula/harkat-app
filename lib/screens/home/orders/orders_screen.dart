import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/pick_drop_order_map/pick_drop_order_map_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .where('driver', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.docs.length == 0) {
          return Center(
            child: Text("0 Orders"),
          );
        }
        return Container(
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      getUiWidth(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${DateTime.parse(snapshot.data.docs[index].data()['date'].toDate().toString())}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontSize: getUiWidth(10)),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: SizedBox(
                      //     height: getUiHeight(120),
                      //     width: double.infinity,
                      //     child: Image.asset(
                      //       "assets/images/staticmap.png",
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: getUiHeight(10)),
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
                                title: "address_from".tr,
                                address:
                                    "${snapshot.data.docs[index].data()['address_from']}",
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
                                title: "address_to".tr,
                                address:
                                    "${snapshot.data.docs[index].data()['address_to']}",
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: getUiHeight(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: getUiWidth(40),
                                height: getUiWidth(40),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(getUiWidth(40)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://ui-avatars.com/api/?name=John+Doe",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: getUiWidth(10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.docs[index].data()['customer']
                                                ['name'] ==
                                            null
                                        ? "---"
                                        : snapshot.data.docs[index]
                                            .data()['customer']['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          snapshot.data.docs[index].data()['status'] !=
                                  'complete'
                              ? SizedBox(
                                  height: getUiHeight(25),
                                  width: getUiWidth(65),
                                  child: RaisedButton(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () async {
                                      Route route = MaterialPageRoute(
                                        builder: (_) => PickDropMapScreen(
                                          orderId: snapshot.data.docs[index].id,
                                        ),
                                      );
                                      Navigator.push(context, route);
                                      var _isComplte =
                                          await Get.to(PickDropMapScreen(
                                        orderId: snapshot.data.docs[index].id,
                                      ));
                                      if (_isComplte == true) {
                                        Get.snackbar(
                                          "Success!",
                                          "Order Completed Successfully",
                                          backgroundColor:
                                              Colors.green.shade500,
                                        );
                                      }
                                    },
                                    child: Text(
                                      "startbtn".tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Text("order_end_lbl".tr)
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.docs.length,
            ),
          ),
        );
      },
    );
  }

  creatOrder() {}
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
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontSize: getUiWidth(10)),
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
