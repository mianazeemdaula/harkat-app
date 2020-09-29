import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/screens/home/components/driver_available_swith.dart';
import 'package:harkat_app/screens/home/map/map_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:provider/provider.dart';

import 'components/home_bottom_nagivation.dart';
import 'components/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.blue),
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
        index: 0,
        children: [
          Container(
            width: double.infinity,
            child: Consumer<LocationProvider>(
              builder: (context, locationServie, child) {
                switch (locationServie.locationStatus) {
                  case LocationStatus.DisableService:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Service Disabled"),
                        RaisedButton(
                          onPressed: () async {
                            await locationServie.requestService();
                          },
                          child: Text("Enable Service"),
                        )
                      ],
                    );
                    break;
                  case LocationStatus.PermissionDenied:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Permission Required"),
                        RaisedButton(
                          onPressed: () async {
                            await locationServie.requestForPermission();
                          },
                          child: Text("Grant Permission"),
                        )
                      ],
                    );
                    break;
                  case LocationStatus.PermissionGranted:
                    return MapScreen();
                    break;
                  default:
                }
                return Center(
                  child: Center(
                    child: Text("Loading.."),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(),
    );
  }
}
