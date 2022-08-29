import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/customer/home/components/order_card.dart';
import 'package:harkat_app/screens/customer/vehicles/vehicle_types.dart';
import 'package:harkat_app/screens/pick_drop_order_map/pick_drop_order_map_screen.dart';
import 'package:harkat_app/screens/rejectorder/reject_order_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:get/get.dart';

class OrderTabScreen extends StatefulWidget {
  @override
  _OrderTabScreenState createState() => _OrderTabScreenState();
}

class _OrderTabScreenState extends State<OrderTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              child: TabBar(
                labelColor: kPrimaryColor,
                tabs: [
                  Tab(child: Text("new_order".tr)),
                  Tab(child: Text("start_order".tr)),
                  Tab(child: Text("cancal_order".tr)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  NewOrderScreen(),
                  Center(child: Text("No Order")),
                  // VehicleTypeScreen(),
                  RejectOrderScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({Key key}) : super(key: key);

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
          color: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      getUiWidth(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    "https://thumbs.dreamstime.com/z/profile-icon-male-avatar-portrait-casual-person-silhouette-face-flat-design-vector-46846328.jpg"),
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
                                  SizedBox(
                                    height: getUiHeight(5),
                                  ),
                                  Text(
                                    "${DateTime.parse(snapshot.data.docs[index].data()['date'].toDate().toString())}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontSize: getUiWidth(10)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          // snapshot.data.docs[index].data()['status'] !=
                          //         'complete'
                          //     ? SizedBox(
                          //         height: getUiHeight(25),
                          //         width: getUiWidth(65),
                          //         child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             primary: kPrimaryColor,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //           ),
                          //           onPressed: () async {
                          //             // Route route = MaterialPageRoute(
                          //             //   builder: (_) => PickDropMapScreen(
                          //             //     orderId: snapshot.data.docs[index].id,
                          //             //   ),
                          //             // );
                          //             // Navigator.push(context, route);
                          //             var _isComplte =
                          //                 await Get.to(() => PickDropMapScreen(
                          //                       orderId: snapshot
                          //                           .data.docs[index].id,
                          //                     ));
                          //             if (_isComplte == true) {
                          //               Get.snackbar(
                          //                 "Success!",
                          //                 "Order Completed Successfully",
                          //                 backgroundColor:
                          //                     Colors.green.shade500,
                          //               );
                          //             }
                          //           },
                          //           child: Text(
                          //             "startbtn".tr,
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ),
                          //       )
                          //     : Text("order_end_lbl".tr)
                        ],
                      ),
                      SizedBox(height: getUiHeight(10)),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                        children: [
                          snapshot.data.docs[index].data()['status'] !=
                                  'complete'
                              ? Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kGreenColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var _isComplte =
                                          await Get.to(() => PickDropMapScreen(
                                                orderId: snapshot
                                                    .data.docs[index].id,
                                              ));
                                      if (_isComplte == true) {
                                        Get.snackbar(
                                          "success".tr,
                                          "order_completed_successfully".tr,
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
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "order_end_lbl".tr,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                          SizedBox(
                            width: getUiWidth(10),
                          ),
                          snapshot.data.docs[index].data()['status'] !=
                                  'complete'
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
                                    },
                                    child: Text("reject".tr),
                                  ),
                                )
                              : Text(""),
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.white),
              itemCount: snapshot.data.docs.length,
            ),
          ),
        );
      },
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
