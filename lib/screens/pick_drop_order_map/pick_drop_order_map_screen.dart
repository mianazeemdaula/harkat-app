import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin, pi, sin, pow;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class PickDropMapScreen extends StatefulWidget {
  final String orderId;

  const PickDropMapScreen({Key key, this.orderId}) : super(key: key);
  @override
  _PickDropMapScreenState createState() => _PickDropMapScreenState();
}

class _PickDropMapScreenState extends State<PickDropMapScreen> {
  // Database
  DocumentReference _orderDatabase;
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
  StreamSubscription<DocumentSnapshot> _orderStreamSubscription;

  // Ui
  Map<String, dynamic> _order;
  String _name, _contact, _senderReciever, _status, _btnText;

  @override
  void initState() {
    super.initState();
    _orderDatabase = FirebaseFirestore.instance.doc("orders/" + widget.orderId);
    Wakelock.enable();
    initOrder();
  }

  Future<void> initOrder() async {
    setState(() {});
    var snapshot = await _orderDatabase.get();
    if (mounted) {
      setState(() {
        _order = snapshot.data();
      });
      processStatus();
      _orderStreamSubscription = _orderDatabase.snapshots().listen((event) {
        if (mounted) {
          setState(() {
            _order = event.data();
          });
          processStatus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ORDER"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 18,
            ),
            padding: EdgeInsets.only(bottom: 100),
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
          // OrderStatusCard(
          //   pickDrop: _pickDrop,
          //   onTap: (int value) {
          //     setState(() {
          //       _pickDrop = value;
          //     });
          //   },
          // ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: bottomCard(),
          ),
        ],
      ),
    );
  }

  Widget bottomCard() {
    return Container(
      height: 100,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  _name ?? "---".toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                GestureDetector(
                  child: Text(
                    _contact ?? "---".toUpperCase(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black.withOpacity(0.5),
                        ),
                  ),
                  onTap: () async {
                    if (_contact != null) {
                      String phone = 'tel:' + _contact;
                      if (await canLaunch(phone)) {
                        launch(phone);
                      }
                    }
                  },
                ),
                Text(
                  _senderReciever ?? "---".toUpperCase(),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _status ?? "---".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16),
                ),
                Text(
                  "STATUS",
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                )
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 2,
            child: FlatButton(
              color: kPrimaryColor,
              child: Text(
                _btnText ?? "---",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: statusBtnProcess,
            ),
          ),
        ],
      ),
    );
  }

  processStatus() {
    if (_order['status'] == 'assigned') {
      _name = _order['sender_name'];
      _contact = _order['sender_contact'];
      _senderReciever = "Sender's";
      _btnText = "Start";
      _status = 'ASSIGN';
    } else if (_order['status'] == 'start') {
      _name = _order['sender_name'];
      _contact = _order['sender_contact'];
      _senderReciever = "Sender's";
      _btnText = "Pick";
      _status = 'START';
    } else if (_order['status'] == 'picked') {
      _name = _order['receiver_name'];
      _contact = _order['receiver_contact'];
      _senderReciever = "Receiver's";
      _btnText = "Deliver";
      _status = 'PICKED';
    } else if (_order['status'] == 'droped') {
      _name = _order['receiver_name'];
      _contact = _order['receiver_contact'];
      _senderReciever = "Receiver's";
      _btnText = "Complete";
      _status = 'DROPED';
    }
  }

  statusBtnProcess() async {
    print(_order['status']);
    LocationData _locationData = await _location.getLocation();
    if (_order['status'] == 'assigned') {
      await _orderDatabase.update({'status': 'start'});
      await buildRoute(
        LatLng(_locationData.latitude, _locationData.longitude),
        LatLng(
          _order['location_from'].latitude,
          _order['location_from'].longitude,
        ),
      );
    } else if (_order['status'] == 'start') {
      double distance = distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          _order['location_from'].latitude,
          _order['location_from'].longitude);
      printInfo(info: distance.toString());
      if (distance > 150) {
        kErrorSnakbar('You are not near to pickup place');
        return;
      }
      await _orderDatabase.update({'status': 'picked'});
      await buildRoute(
        LatLng(_locationData.latitude, _locationData.longitude),
        LatLng(_order['location_to'].latitude, _order['location_to'].longitude),
      );
    } else if (_order['status'] == 'picked') {
      if (distanceBetween(_locationData.latitude, _locationData.longitude,
              _order['location_to'].latitude, _order['location_to'].longitude) >
          150) {
        kErrorSnakbar('You are not near to drop place');
        return;
      }
      await _orderDatabase.update({'status': 'droped'});
      setState(() {
        _polyLines.clear();
      });
    } else if (_order['status'] == 'droped') {
      double amount = double.parse(_order['amount'].toString());
      String userId = FirebaseAuth.instance.currentUser.uid;
      String dayKey = 'earing_day_${DateTime.now().day}';
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'balance': FieldValue.increment(amount),
        dayKey: FieldValue.increment(amount),
      });
      await _orderDatabase.update({'status': 'complete'});
      Get.back(result: true);
    }
  }

  Widget bottomSheet() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Text("Boottom Sheet"),
    );
  }

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
    if (data != null && mounted) {
      await buildReRoutingIfRequired(LatLng(data.latitude, data.longitude));
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
    _orderStreamSubscription?.cancel();
    Wakelock.disable();
    super.dispose();
  }

  Future<void> buildRoute(LatLng from, LatLng to) async {
    var params = {
      "origin": "${from.latitude},${from.longitude}",
      "destination": "${to.latitude},${to.longitude}",
      "mode": "driving",
      "avoidHighways": "false",
      "avoidFerries": "true",
      "avoidTolls": "false",
      "key": googleMapApi
    };

    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);
    var response = await http.get(Uri.parse(uri.toString()));
    String newTiming = '';
    if (response?.statusCode == 200) {
      newTiming =
          jsonDecode(response.body)['routes'][0]['legs'][0]['duration']['text'];
      await _orderDatabase.update({'time': newTiming});
    }
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapApi,
      PointLatLng(from.latitude, from.longitude),
      PointLatLng(to.latitude, to.longitude),
      travelMode: TravelMode.driving,
    );
    _listOfPolylinePoints.clear();
    if (result.points.length > 0) {
      result.points
        ..forEach((PointLatLng point) {
          _listOfPolylinePoints.add(LatLng(point.latitude, point.longitude));
        });
      setState(() {
        PolylineId _polyLineId = PolylineId('poly');
        _polyLines[_polyLineId] = Polyline(
          polylineId: _polyLineId,
          width: 10,
          points: _listOfPolylinePoints,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.green,
        );
      });
    }
  }

  List<LatLng> _listOfPolylinePoints = [];

  Future buildReRoutingIfRequired(LatLng latLng) async {
    bool needReRouting = false;
    _listOfPolylinePoints.forEach((point) {
      if (distanceBetween(point.latitude, point.longitude, latLng.latitude,
              latLng.longitude) <
          15) {
        needReRouting = true;
      }
    });
    if (!needReRouting) {
      if (_order['status'] == 'start') {
        await buildRoute(
          LatLng(latLng.latitude, latLng.longitude),
          LatLng(
            _order['location_from'].latitude,
            _order['location_from'].longitude,
          ),
        );
      } else if (_order['status'] == 'picked') {
        await buildRoute(
          LatLng(latLng.latitude, latLng.longitude),
          LatLng(
            _order['location_to'].latitude,
            _order['location_to'].longitude,
          ),
        );
      }
    }
  }

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  _toRadians(double degree) {
    return degree * pi / 180;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _positionStreamSubscription?.cancel();
  // }
}
