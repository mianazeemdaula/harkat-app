import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
        controller.setMapStyle(mapsStyle);
        _googleMapController.complete(controller);
        startStream();
      },
    );
  }

  startStream() async {
    try {
      print("Map Stream Started");
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
}

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   // UI Variables
//   GoogleMapController _googleMapController;

//   // Location
//   StreamSubscription<LocationData> _positionStreamSubscription;
//   MapLocationProvider _mapLocationProvider;
//   BuildContext _buildContext;

//   @override
//   void initState() {
//     super.initState();

//     // initLocationStream(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MapLocationProvider(),
//       builder: (context, child) {
//         print("Rebuild Map Screen");
//         return Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(0, 0),
//                 zoom: 17,
//               ),
//               mapType: MapType.normal,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               trafficEnabled: true,
//               markers: context.select<MapLocationProvider, Set<Marker>>(
//                   (value) => value.markers),
//               onMapCreated: (GoogleMapController controller) {
//                 _googleMapController = controller;
//                 _googleMapController.setMapStyle(mapsStyle);
//                 context.read<MapLocationProvider>().startStream(controller);
//                 // context.read<MapLocationProvider>().addMarker(
//                 //     icon: "assets/images/my_position_marker.png",
//                 //     id: "my-position",
//                 //     position: LatLng(0, 0));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _positionStreamSubscription?.cancel();
//   }
// }
