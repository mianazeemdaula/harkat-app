import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/cloud_messaging.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/screens/home/components/driver_available_swith.dart';
import 'package:harkat_app/screens/home/earnings/earnings_screen.dart';
import 'package:harkat_app/screens/home/map/map_screen.dart';
import 'package:harkat_app/screens/home/orders/orders_screen.dart';
import 'package:harkat_app/widgets/map_service_widget.dart';
import 'package:harkat_app/widgets/permission/location_permission.dart';
import 'package:provider/provider.dart';

import 'components/home_bottom_nagivation.dart';
import 'components/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  CloudMessaging _cmInstant;
  @override
  void initState() {
    super.initState();
    _cmInstant = CloudMessaging.instance;
    _cmInstant.setContext(context);
    // FCMHelper.setupFCM(context);
    FirebaseMessaging().getToken().then((value) {
      FirebaseFirestore.instance.collection("users")
        ..doc(widget.user.uid).update({'token': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconTheme.of(context).copyWith(color: kPrimaryColor),
        title: DriverAvailabeSwith(
          textOn: "online_driver".tr(),
          textOff: "offline_driver".tr(),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(250),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: "https://ui-avatars.com/api/?name=Elon+Musk",
              ),
            ),
          )
        ],
      ),
      drawer: HomeDrawer(),
      body: IndexedStack(
        index: pageIndex,
        children: [
          Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
              if (locationProvider.isSteamLocation == false) {
                return LocationPermission(
                  provider: locationProvider,
                );
              } else {
                return MapScreen();
              }
            },
          ),
          OrdersScreen(),
          EarningScreen()
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        index: pageIndex,
        onTap: (int i) {
          setState(() {
            pageIndex = i;
          });
        },
      ),
    );
  }
}
