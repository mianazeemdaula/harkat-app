import 'package:flutter/material.dart';
import 'package:harkat_app/screens/customer/place_order/pickup/pickup_address.dart';
import 'package:harkat_app/screens/home/components/home_drawer.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/default_button.dart';

class CustomerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: HomeDrawer(),
      body: Center(
        child: Text("CUSTOMER DASHBOARD"),
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
