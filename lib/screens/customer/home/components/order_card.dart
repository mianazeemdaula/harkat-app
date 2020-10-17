import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';

class OrderCard extends StatelessWidget {
  final DocumentSnapshot order;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateTime.parse(order.data()['date'].toDate().toString())}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: getUiWidth(10)),
              ),
              Text(
                "${order.data()['status']}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildContactRow(
                context,
                order.data()['sender_name'],
                order.data()['sender_contact'],
              ),
              Icon(Icons.arrow_forward_ios),
              buildContactRow(
                context,
                order.data()['receiver_name'],
                order.data()['receiver_contact'],
              ),
              order.data()['status'] != 'complete'
                  ? SizedBox(
                      width: 100,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hoverColor: kPrimaryColor,
                        onPressed: () {},
                        child: Text(
                          "Track",
                        ),
                      ),
                    )
                  : Text("Complete")
            ],
          )
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
