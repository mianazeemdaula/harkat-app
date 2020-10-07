import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/providers/map_location_provider.dart';
import 'package:harkat_app/services/location_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // UI Variables
  GoogleMapController _googleMapController;

  // Location
  StreamSubscription<LocationData> _positionStreamSubscription;
  MapLocationProvider _mapLocationProvider;

  @override
  void initState() {
    super.initState();
    initLocationStream();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapLocationProvider(),
      builder: (context, child) {
        return Consumer<MapLocationProvider>(
          builder: (context, value, child) {
            _mapLocationProvider = value;
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 17,
                  ),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  trafficEnabled: true,
                  markers: value.markers,
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController = controller;
                    _googleMapController.setMapStyle(mapsStyle);
                    value.addMarker(
                        icon: "assets/images/my_position_marker.png",
                        id: "my-position",
                        position: LatLng(0, 0));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  initLocationStream() {
    _positionStreamSubscription =
        Provider.of<LocationProvider>(context, listen: false)
            .locationStream
            .listen((event) {
      if (event != null) {
        _mapLocationProvider.addMarker(
            icon: "assets/images/my_position_marker.png",
            id: "my-position",
            position: LatLng(event.latitude, event.longitude));
        CameraPosition cPosition = CameraPosition(
            target: LatLng(event.latitude, event.longitude), zoom: 17);
        _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cPosition));
      }
      ;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription?.cancel();
  }
}
