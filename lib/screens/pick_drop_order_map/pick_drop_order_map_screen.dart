import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:location/location.dart';

import 'components/order_status_card.dart';

class PickDropMapScreen extends StatefulWidget {
  final String orderId;

  const PickDropMapScreen({Key key, this.orderId}) : super(key: key);
  @override
  _PickDropMapScreenState createState() => _PickDropMapScreenState();
}

class _PickDropMapScreenState extends State<PickDropMapScreen> {
  // Location Services
  Location _location = new Location();

  // Google Maps Variables
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  Completer<GoogleMapController> _googleMapController = Completer();
  MarkerId _markerId = MarkerId("my-location");
  MarkerId _destinationMarkerId = MarkerId("destination-location");
  BitmapDescriptor _markerIcon;
  StreamSubscription<LocationData> _streamSubscription;

  // Ui
  int _pickDrop = 0;
  Map<String, dynamic> _order;

  @override
  void initState() {
    super.initState();
    startOrder();
  }

  startOrder() async {
    var snapshot =
        await FirebaseFirestore.instance.doc("orders/${widget.orderId}").get();
    setState(() {
      _order = snapshot.data();
    });
    LocationData _locationData = await _location.getLocation();
    if (_order['status'] == 'assigned') {
      await buildRoute(
          LatLng(_locationData.latitude, _locationData.longitude),
          LatLng(_order['location_from'].latitude,
              _order['location_from'].longitude));
    } else if (_order['status'] == 'picked') {
      await buildRoute(
          LatLng(_locationData.latitude, _locationData.longitude),
          LatLng(
              _order['location_to'].latitude, _order['location_to'].longitude));
    }
    FirebaseFirestore.instance
        .doc("orders/${widget.orderId}")
        .snapshots()
        .listen((event) {
      setState(() {
        _order = event.data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 18,
            ),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            trafficEnabled: true,
            markers: Set<Marker>.from(_markers.values),
            polylines: Set<Polyline>.from(_polyLines.values),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapsStyle);
              _googleMapController.complete(controller);
              startStream();
            },
          ),
          OrderStatusCard(
            pickDrop: _pickDrop,
            onTap: (int value) {
              setState(() {
                _pickDrop = value;
              });
            },
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: MapServieWidget(
  //         mapWidget: Stack(
  //           children: [
  //             GoogleMap(
  //               initialCameraPosition: CameraPosition(
  //                 target: LatLng(
  //                   Provider.of<LocationProvider>(context, listen: false)
  //                       .position
  //                       .latitude,
  //                   Provider.of<LocationProvider>(context, listen: false)
  //                       .position
  //                       .longitude,
  //                 ),
  //                 zoom: 18,
  //               ),
  //               mapToolbarEnabled: false,
  //               myLocationEnabled: true,
  //               padding: EdgeInsets.only(top: getUiWidth(150)),
  //               markers: Set<Marker>.from(markers.values),
  //               polylines: Set<Polyline>.from(_polyLines.values),
  //               onMapCreated: (GoogleMapController controller) {
  //                 controller.setMapStyle(mapsStyle);
  //                 setState(() {
  //                   _googleMapController = controller;
  //                 });
  //               },
  //             ),
  //             OrderStatusCard(
  //               pickDrop: _pickDrop,
  //               onTap: (int value) {
  //                 setState(() {
  //                   _pickDrop = value;
  //                 });
  //               },
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  startStream() async {
    try {
      _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/images/my_position_marker.png",
      );
      PermissionStatus _permission = await _location.requestPermission();
      if (_permission == PermissionStatus.granted) {
        bool service = await _location.requestService();
        if (service == true) {
          _streamSubscription = _location.onLocationChanged.listen(
            (data) => changePositionMarker(data),
          );
        }
      }
    } catch (e) {
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
      print("$e");
    }
  }

  changePositionMarker(LocationData data) async {
    GoogleMapController _controller = await _googleMapController.future;
    if (data != null) {
      setState(() {
        _markers[_markerId] = Marker(
          markerId: _markerId,
          icon: _markerIcon,
          position: LatLng(data.latitude, data.longitude),
          zIndex: 2,
        );
      });
      var cameraPosition = CameraPosition(
        target: LatLng(data.latitude, data.longitude),
        zoom: await _controller.getZoomLevel(),
      );
      var cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
      _controller.animateCamera(cameraUpdate);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> buildRoute(LatLng from, LatLng to) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApi,
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude),
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
            color: kMapRoutePickupColor);
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _positionStreamSubscription?.cancel();
  // }
}
