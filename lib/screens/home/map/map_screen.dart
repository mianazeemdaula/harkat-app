import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    initLocationStream();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
                Provider.of<LocationProvider>(context, listen: false)
                    .position
                    .latitude,
                Provider.of<LocationProvider>(context, listen: false)
                    .position
                    .longitude),
            zoom: 17,
          ),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          trafficEnabled: true,
          markers: Set<Marker>.from(markers.values),
          polylines: Set<Polyline>.from(_polyLines.values),
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _googleMapController.setMapStyle(mapsStyle);
            setState(() {});
          },
        ),
      ],
    );
  }

  initLocationStream() {
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

    _positionStreamSubscription = getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 5)
        .listen(
      (Position position) {
        if (position != null && _googleMapController != null) {
          Marker driver = markers[_driverMarkerId];
          setState(() {
            markers[_driverMarkerId] = driver.copyWith(
              positionParam: LatLng(position.latitude, position.longitude),
            );
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

  Future<void> buildRoute() async {
    Position _myPosition =
        Provider.of<LocationProvider>(context, listen: false).position;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApi,
        PointLatLng(_myPosition.latitude, _myPosition.longitude),
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
