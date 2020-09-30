import 'package:flutter/material.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:provider/provider.dart';

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
              return mapWidget;
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
    );
  }
}
