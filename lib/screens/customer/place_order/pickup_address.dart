import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/providers/location_service_provider.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/map_service_widget.dart';
import 'package:provider/provider.dart';

class PickUpAddressScreen extends StatefulWidget {
  @override
  _PickUpAddressScreenState createState() => _PickUpAddressScreenState();
}

class _PickUpAddressScreenState extends State<PickUpAddressScreen> {
  // Ui Variables
  Position _location;
  @override
  void initState() {
    super.initState();
    _location = Provider.of<LocationProvider>(context, listen: false).position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          MapServieWidget(
            mapWidget: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _location == null
                    ? LatLng(0, 0)
                    : LatLng(_location.latitude, _location.longitude),
              ),
            ),
          ),
          Positioned(
            top: getUiHeight(10),
            left: getUiWidth(10),
            right: getUiWidth(10),
            child: Container(
              padding: EdgeInsets.all(getUiWidth(10)),
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Text("Address of the location"),
                  SizedBox(width: getUiWidth(10)),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
