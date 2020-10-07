import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/providers/map_location_provider.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/permission/location_permission.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';
import 'components/conctact_card.dart';

class DropAddressScreen extends StatefulWidget {
  @override
  _DropAddressScreenState createState() => _DropAddressScreenState();
}

class _DropAddressScreenState extends State<DropAddressScreen> {
  // Ui Variables
  GoogleMapController _googleMapController;
  LatLng lastDragpostition;
  @override
  void initState() {
    super.initState();
  }

  Location location = Location();

  loadPermissions() async {
    await location.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    print("Pickup Address Screen");
    return Scaffold(
      appBar: AppBar(
        title: Text("Drop Location"),
        centerTitle: true,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isSteamLocation == false) {
            return LocationPermission(
              provider: locationProvider,
            );
          } else {
            return ChangeNotifierProvider(
              create: (context) => MapLocationProvider(),
              builder: (context, child) {
                return Consumer<MapLocationProvider>(
                  builder: (context, value, child) {
                    return Stack(
                      overflow: Overflow.visible,
                      children: [
                        buildGoogleMaps(locationProvider.locationData),
                        AddressCard(
                          mapLocationProvider: value,
                        ),
                        ContactCard(
                          mapLocationProvider: value,
                        )
                      ],
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildGoogleMaps(LocationData position) {
    return Consumer<MapLocationProvider>(
      builder: (context, value, child) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17,
          ),
          padding: EdgeInsets.only(top: getUiHeight(75)),
          markers: value.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController _controller) {
            _controller.setMapStyle(mapsStyle);
            _googleMapController = _controller;
            lastDragpostition = LatLng(position.latitude, position.longitude);
          },
          onCameraMove: (CameraPosition _postition) {
            value.addMarker(
              id: "my-position",
              position: LatLng(
                  _postition.target.latitude, _postition.target.longitude),
              icon: "assets/images/my_position_marker.png",
            );
            lastDragpostition = _postition.target;
          },
          onCameraIdle: () {
            value.getAddressFromLocation(
                lastDragpostition.latitude, lastDragpostition.longitude);
          },
        );
      },
    );
  }
}
