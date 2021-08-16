import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  const TrackOrderScreen({Key key, this.orderId}) : super(key: key);
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Database
  DocumentReference _orderDatabase;
  // Location Services
  Location _location = new Location();

  // Google Maps Variables
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  Completer<GoogleMapController> _googleMapController = Completer();
  MarkerId _markerId = MarkerId("driver-location");
  BitmapDescriptor _markerIcon;
  StreamSubscription<DocumentSnapshot> _orderStreamSubscription;

  // Ui
  Map<String, dynamic> _order;
  Map<String, dynamic> _driver;
  String _name, _amount, _status;

  String driverId;

  @override
  void initState() {
    super.initState();
    _orderDatabase = FirebaseFirestore.instance.doc("orders/" + widget.orderId);
    Wakelock.enable();
    initOrder();
  }

  Future<void> initOrder() async {
    var snapshot = await _orderDatabase.get();
    if (mounted) {
      setState(() {
        _order = snapshot.data();
        driverId = _order['driver'];
      });
      processStatus();
      bool isPermission = await isLocationPermission();
      _orderStreamSubscription = _orderDatabase.snapshots().listen((event) {
        if (mounted) {
          setState(() {
            _order = event.data();
          });
          processStatus();
        }
      });
      if (isPermission && _order['status'] != 'open') {
        FirebaseFirestore.instance.doc("users/" + driverId).snapshots().listen(
          (event) {
            _driver = event.data();
            changePositionMarker(
              LatLng(
                event.data()['coordinates'].latitude,
                event.data()['coordinates'].longitude,
              ),
            );
          },
        );
      }
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
              target: LatLng(24.438547, 54.526620),
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
              // controller.setMapStyle(mapsStyle);
              _googleMapController.complete(controller);
            },
          ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _amount ?? "---".toUpperCase(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "Amount to Pay",
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
            child: Column(
              children: [
                Text(
                  _driver != null ? _driver['name'] : "---".toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                GestureDetector(
                  child: Text(
                    _driver != null
                        ? _driver['contact'].toString()
                        : "---".toUpperCase(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black.withOpacity(0.5),
                        ),
                  ),
                  onTap: () async {
                    if (_driver != null) {
                      String phone = 'tel:' + _driver['contact'];
                      if (await canLaunch(phone)) {
                        launch(phone);
                      }
                    }
                  },
                ),
                Text(
                  'Driver',
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void processStatus() {
    if (_order['status'] == 'open') {
      _name = _order['sender_name'];
      _amount = _order['amount'].toString() + "AED";
      _status = 'OPEN';
    } else if (_order['status'] == 'assigned') {
      _name = _order['sender_name'];
      _amount = _order['amount'].toString() + "AED";
      _status = 'ASSIGN';
    } else if (_order['status'] == 'start') {
      _name = _order['sender_name'];
      _amount = _order['amount'].toString() + "AED";
      _status = 'START';
    } else if (_order['status'] == 'picked') {
      _name = _order['receiver_name'];
      _amount = _order['amount'].toString() + "AED";
      _status = 'PICKED';
    } else if (_order['status'] == 'droped') {
      _name = _order['receiver_name'];
      _amount = _order['amount'].toString() + "AED";
      _status = 'DROPED';
    }
    setState(() {});
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

  Future<bool> isLocationPermission() async {
    try {
      _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/images/my_position_marker.png",
      );
      PermissionStatus _permission = await _location.requestPermission();
      if (_permission == PermissionStatus.granted) {
        bool service = await _location.requestService();
        if (service == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
      print("$e");
      return false;
    }
  }

  changePositionMarker(LatLng data) async {
    GoogleMapController _controller = await _googleMapController.future;
    if (data != null && mounted) {
      setState(() {
        _markers[_markerId] = Marker(
          markerId: _markerId,
          icon: _markerIcon,
          position: data,
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
    _orderStreamSubscription?.cancel();
    Wakelock.disable();
    super.dispose();
  }
}
