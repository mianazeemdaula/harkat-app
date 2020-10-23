import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/customer/home/components/order_card.dart';
import 'package:harkat_app/screens/customer/place_order/pickup/pickup_address.dart';
import 'package:harkat_app/screens/home/components/home_drawer.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harkat"),
        centerTitle: true,
      ),
      drawer: HomeDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where('customer',
                isEqualTo: context
                    .select<UserRepository, String>((value) => value.user.uid))
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: snapshot.data.docs[index],
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route =
              MaterialPageRoute(builder: (_) => PickUpAddressScreen());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
