import 'package:flutter/material.dart';
import 'package:harkat_app/providers/location_service_provider.dart';

class LocationPermission extends StatelessWidget {
  final LocationProvider provider;

  const LocationPermission({Key key, this.provider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (provider.status) {
            case LocationStatus.NeedLocationService:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Need Service"),
                  RaisedButton(
                    onPressed: () {
                      provider.initLocationServices();
                    },
                    child: Text("Enable Service"),
                  )
                ],
              );
              break;
            case LocationStatus.PermissionDenied:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Need Permission"),
                  RaisedButton(
                    onPressed: () {
                      provider.initLocationServices();
                    },
                    child: Text("Enable Permission"),
                  )
                ],
              );
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
