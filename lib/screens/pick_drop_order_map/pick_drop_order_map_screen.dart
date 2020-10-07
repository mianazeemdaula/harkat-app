import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/map_service_widget.dart';
import 'package:location/location.dart';
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
  LocationData _position;
  StreamSubscription<LocationData> _positionStreamSubscription;
  int _pickDrop = 0;

  @override
  void initState() {
    super.initState();
    // setStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
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

  // Future<void> setStream() async {
  //   getLastKnownPosition().then((value) {
  //     print("$value");
  //     if (mounted && value != null) {
  //       setState(() {
  //         _position = value;
  //         markers[_driverMarkerId] = Marker(
  //           markerId: _driverMarkerId,
  //           position: LatLng(value.latitude, value.longitude),
  //         );
  //       });

  //       buildRoute(value);
  //     }
  //     _positionStreamSubscription = getPositionStream(
  //             desiredAccuracy: LocationAccuracy.bestForNavigation,
  //             distanceFilter: 5)
  //         .listen(
  //       (Position position) => changeDriverPin(position),
  //     );
  //   });
  // }

  // Future<void> changeDriverPin(Position position) async {
  //   if (position != null && _googleMapController != null) {
  //     double zoom = await _googleMapController.getZoomLevel();
  //     Marker driver = markers[_driverMarkerId];
  //     setState(() {
  //       markers[_driverMarkerId] = driver.copyWith(
  //         positionParam: LatLng(position.latitude, position.longitude),
  //       );
  //     });
  //     CameraPosition cPosition = CameraPosition(
  //         target: LatLng(position.latitude, position.longitude), zoom: zoom);
  //     _googleMapController
  //         .animateCamera(CameraUpdate.newCameraPosition(cPosition));
  //   }
  // }

  // Future<void> buildRoute(Position position) async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleMapApi,
  //       PointLatLng(position.latitude, position.longitude),
  //       PointLatLng(30.798352, 73.426983),
  //       travelMode: TravelMode.driving);
  //   if (result.points.length > 0) {
  //     List<LatLng> _latLngs = [];
  //     result.points
  //       ..forEach((PointLatLng point) {
  //         _latLngs.add(LatLng(point.latitude, point.longitude));
  //       });
  //     setState(() {
  //       PolylineId _polyLineId = PolylineId('poly');
  //       _polyLines[_polyLineId] = Polyline(
  //           polylineId: _polyLineId,
  //           width: 10,
  //           points: _latLngs,
  //           startCap: Cap.roundCap,
  //           endCap: Cap.roundCap,
  //           color: kMapRoutePickupColor);
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _positionStreamSubscription?.cancel();
  // }
}
