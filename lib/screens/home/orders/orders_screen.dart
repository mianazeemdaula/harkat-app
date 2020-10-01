import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/pick_drop_order_map/pick_drop_order_map_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
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
                          "30 Sep, 2020 02:05PM",
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
                              title: "address_from".tr(),
                              address: "Address form where pickup the order",
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
                              title: "address_to".tr(),
                              address: "Address where drop the order",
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
                                      "https://randomuser.me/api/portraits/men/75.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: getUiWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Abu Jamal",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "4.5",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 12),
                                    ),
                                    SizedBox(width: getUiWidth(5)),
                                    Icon(
                                      Icons.star,
                                      size: getUiWidth(12),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        index == 1
                            ? SizedBox(
                                height: getUiHeight(25),
                                width: getUiWidth(65),
                                child: RaisedButton(
                                  color: kPrimaryColor,
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (_) => PickDropMapScreen());
                                    Navigator.push(context, route);
                                  },
                                  child: Text(
                                    "startbtn".tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : Text("order_end_lbl".tr())
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: 25),
      ),
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
