import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'components/new_order_card.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // UI Variables
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId _driverMarkerId = MarkerId('driver');
  BitmapDescriptor sellerLocationIcon;
  BitmapDescriptor topSellerLocationIcon;

  // Location
  StreamSubscription<Position> _positionStream;
  Position _position;

  @override
  void initState() {
    super.initState();
    getLastKnownPosition().then((value) {
      if (mounted) {
        setState(() {
          _position = value;
          markers[_driverMarkerId] = Marker(
            markerId: _driverMarkerId,
            position: LatLng(value.latitude, value.longitude),
          );
        });
      }
    });

    _positionStream = getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen(
      (Position position) {
        if (position != null) {
          Marker driver = markers[_driverMarkerId];
          setState(() {
            markers[_driverMarkerId] = driver.copyWith(
                positionParam: LatLng(position.latitude, position.longitude));
          });
          CameraPosition cPosition = CameraPosition(
              target: LatLng(position.latitude, position.longitude), zoom: 17);
          _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(cPosition));
        }
        print(position == null
            ? 'Unknown'
            : position.latitude.toString() +
                ', ' +
                position.longitude.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
                Provider.of<LocationProvider>(context).position.latitude,
                Provider.of<LocationProvider>(context).position.longitude),
            zoom: 17,
          ),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          trafficEnabled: true,
          markers: Set<Marker>.from(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _googleMapController.setMapStyle(mapsStyle);
          },
        ),
        // NewOrderCard(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
