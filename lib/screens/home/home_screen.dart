import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/screens/home/components/driver_available_swith.dart';
import 'package:harkat_app/screens/home/map/map_screen.dart';
import 'package:harkat_app/screens/home/orders/orders_screen.dart';
import 'package:harkat_app/widgets/map_service_widget.dart';

import 'components/home_bottom_nagivation.dart';
import 'components/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
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
          MapServieWidget(
            mapWidget: MapScreen(),
          ),
          OrdersScreen(),
          Center(
            child: Text("EARNINGs"),
          )
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
