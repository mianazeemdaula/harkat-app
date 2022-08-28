import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/helpers/cloud_messaging.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/customer/home/components/order_card.dart';
import 'package:harkat_app/screens/customer/place_order/pickup/pickup_address.dart';
import 'package:harkat_app/screens/home/components/home_drawer.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  CloudMessaging _cmInstant;
  @override
  void initState() {
    super.initState();
    _cmInstant = CloudMessaging.instance;
    _cmInstant.setContext(context);
    String uId = context.read<UserRepository>().user.uid;
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseFirestore.instance.collection("users")
        ..doc(uId).update({'token': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("harkat".tr),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      drawer: HomeDrawer(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where('customer.id',
                isEqualTo: context
                    .select<UserRepository, String>((value) => value.user.uid))
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                "Create Your First Order".toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          }
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
        onPressed: () async {
          Route route =
              MaterialPageRoute(builder: (_) => PickUpAddressScreen());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
