import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/screens/home/map/components/new_order_card.dart';
import 'package:harkat_app/widgets/map_service_widget.dart';
import 'package:provider/provider.dart';

import 'components/order_status_card.dart';

class PickDropMapScreen extends StatefulWidget {
  @override
  _PickDropMapScreenState createState() => _PickDropMapScreenState();
}

class _PickDropMapScreenState extends State<PickDropMapScreen> {
  // UI Variables
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  MarkerId _driverMarkerId = MarkerId('driver');
  BitmapDescriptor sellerLocationIcon;
  BitmapDescriptor topSellerLocationIcon;

  // Location
  Position _position;
  StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    setStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MapServieWidget(
          mapWidget: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    Provider.of<LocationProvider>(context, listen: false)
                        .position
                        .latitude,
                    Provider.of<LocationProvider>(context, listen: false)
                        .position
                        .longitude,
                  ),
                  zoom: 18,
                ),
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                markers: Set<Marker>.from(markers.values),
                polylines: Set<Polyline>.from(_polyLines.values),
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = controller;
                  _googleMapController.setMapStyle(mapsStyle);
                  setState(() {});
                },
              ),
              OrderStatusCard()
            ],
          ),
        ),
      ),
    );
  }

  setStream() async {
    getLastKnownPosition().then((value) {
      if (mounted) {
        setState(() {
          _position = value;
          markers[_driverMarkerId] = Marker(
            markerId: _driverMarkerId,
            position: LatLng(value.latitude, value.longitude),
          );
        });

        buildRoute(value);
      }
    });
    _positionStreamSubscription = getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 5)
        .listen(
      (Position position) => changeDriverPin(position),
    );
  }

  Future<void> changeDriverPin(Position position) async {
    double zoom = await _googleMapController.getZoomLevel();
    if (position != null) {
      Marker driver = markers[_driverMarkerId];
      setState(() {
        markers[_driverMarkerId] = driver.copyWith(
          positionParam: LatLng(position.latitude, position.longitude),
        );
      });
      CameraPosition cPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: zoom);
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cPosition));
    }
  }

  Future<void> buildRoute(Position position) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApi,
        PointLatLng(position.latitude, position.longitude),
        PointLatLng(30.798352, 73.426983),
        travelMode: TravelMode.driving);
    if (result.points.length > 0) {
      List<LatLng> _latLngs = [];
      result.points
        ..forEach((PointLatLng point) {
          _latLngs.add(LatLng(point.latitude, point.longitude));
        });
      setState(() {
        PolylineId _polyLineId = PolylineId('poly');
        _polyLines[_polyLineId] = Polyline(
            polylineId: _polyLineId,
            width: 10,
            points: _latLngs,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            color: Colors.blue);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription?.cancel();
  }
}
