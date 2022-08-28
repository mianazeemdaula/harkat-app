import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  // Location Services
  Location _location = new Location();

  // Google Maps Variables
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _googleMapController = Completer();
  MarkerId _markerId = MarkerId("my-location");
  BitmapDescriptor _markerIcon;
  StreamSubscription<LocationData> _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
        zoom: 18,
      ),
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      trafficEnabled: true,
      markers: Set<Marker>.from(_markers.values),
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(newMapStyle);
        _googleMapController.complete(controller);
        startStream();
      },
    );
  }

  bool service = false;

  startStream() async {
    try {
      print("Map Stream Started");
      _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/images/my_position_marker.png",
      );
      PermissionStatus _permission = await _location.requestPermission();
      if (_permission == PermissionStatus.granted) {
        service = await _location.requestService();
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
      await context
          .read<UserRepository>()
          .sendLocation(LatLng(data.latitude, data.longitude));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("App Inactive");
        break;
      case AppLifecycleState.paused:
        print("App Paused");
        break;
      case AppLifecycleState.resumed:
        print("App Resumed");
        if (!service) {
          startStream();
        }
        break;
      case AppLifecycleState.detached:
        print("App Detached");
        break;
    }
  }
}
