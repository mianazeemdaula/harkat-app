import 'package:flutter/material.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MapServieWidget extends StatelessWidget {
  const MapServieWidget({
    Key key,
    this.mapWidget,
  }) : super(key: key);

  final Widget mapWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Consumer<LocationProvider>(
        builder: (context, locationServie, child) {
          // switch (locationServie.) {
          //   case LocationStatus.NeedLocationService:
          //     return LocationEnableService();
          //     break;
          //   case LocationStatus.PermissionDenied:
          //     return LocationPermissionDenied();
          //     break;
          //   case LocationStatus.PermissionGranted:
          //     return mapWidget;
          //     break;
          //   default:
          // }
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
        },
      ),
    );
  }
}

class LocationEnableService extends StatelessWidget {
  const LocationEnableService({
    Key key,
    this.locationProvider,
  }) : super(key: key);
  final LocationProvider locationProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("location_service_enable_lbl".tr()),
          RaisedButton(
            onPressed: () async {
              // await locationProvider.();
            },
            child: Text("location_service_enable_btn".tr()),
          )
        ],
      ),
    );
  }
}

class LocationPermissionDenied extends StatelessWidget {
  const LocationPermissionDenied({
    Key key,
    this.locationProvider,
  }) : super(key: key);
  final LocationProvider locationProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("location_service_permission_lbl".tr()),
        RaisedButton(
          onPressed: () async {
            // await locationProvider.requestForPermission();
          },
          child: Text("location_service_permission_btn".tr()),
        )
      ],
    );
  }
}
