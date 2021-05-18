import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/helpers/maps_helper.dart';
import 'package:harkat_app/model/address_from_geocode.dart';
import 'package:harkat_app/providers/pick_drop_order_prodiver.dart';
import 'package:harkat_app/screens/customer/place_order/drop/drop_address.dart';
import 'package:harkat_app/size_config.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'components/address_card.dart';
import 'components/conctact_card.dart';
import 'package:http/http.dart' as http;

class PickUpAddressScreen extends StatefulWidget {
  @override
  _PickUpAddressScreenState createState() => _PickUpAddressScreenState();
}

class _PickUpAddressScreenState extends State<PickUpAddressScreen> {
  // Location Services
  Location _location = new Location();

  // Google Maps Variables
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _googleMapController = Completer();
  MarkerId _markerId = MarkerId("my-location");
  BitmapDescriptor _markerIcon;

  Future _myLoactionFuture;

  // Pickup Locaiton
  AddressFromGeoCode _pickupAddress;
  LatLng _lastPickupAddress;

  // Pickup Address
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _contactTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myLoactionFuture = _location.getLocation();
    setMarker();
  }

  setMarker() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/my_position_marker.png",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => mounted ? true : false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pickup Location"),
          centerTitle: true,
        ),
        body: FutureBuilder<LocationData>(
          future: _myLoactionFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              overflow: Overflow.visible,
              children: [
                buildGoogleMaps(snapshot.data),
                AddressCard(
                  address: _pickupAddress,
                ),
                ContactCard(
                  formKey: _formKey,
                  nameTextController: _nameTextController,
                  contactTextController: _contactTextController,
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      await context.read<PickDropOrderProvider>().setPickup(
                            _pickupAddress,
                            _nameTextController.text,
                            _contactTextController.text,
                          );
                      Route route = MaterialPageRoute(
                        builder: (_) => DropAddressScreen(),
                      );
                      Navigator.push(context, route);
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildGoogleMaps(LocationData position) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      ),
      padding: EdgeInsets.only(top: getUiHeight(75)),
      markers: Set<Marker>.from(_markers.values),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController _controller) {
        _controller.setMapStyle(mapsStyle);
        _googleMapController.complete(_controller);
        getAddressFromLocation(position.latitude, position.longitude);
        setState(() {
          _markers[_markerId] = Marker(
            markerId: _markerId,
            position: LatLng(position.latitude, position.longitude),
            icon: _markerIcon,
          );
        });
      },
      onCameraMove: (CameraPosition _postition) {
        _lastPickupAddress = LatLng(
          _postition.target.latitude,
          _postition.target.longitude,
        );
        setState(() {
          _markers[_markerId] = _markers[_markerId].copyWith(
            positionParam: _lastPickupAddress,
          );
        });
      },
      onCameraIdle: () {
        if (_lastPickupAddress != null) {
          getAddressFromLocation(
              _lastPickupAddress.latitude, _lastPickupAddress.longitude);
        }
      },
    );
  }

  Future<void> getAddressFromLocation(double lat, double lng) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapApi";
    try {
      http.Response _response = await http.get(Uri.parse(url));
      print("$url");
      if (_response.statusCode == 200) {
        Map<String, dynamic> _result = jsonDecode(_response.body);
        if (_result.containsKey('results')) {
          setState(() {
            _pickupAddress = AddressFromGeoCode(
              formattedAddress: _result['results'][0]['formatted_address'],
              latitude: lat,
              longitude: lng,
            );
          });
        }
      }
    } catch (e) {
      print("$e");
    }
  }
}
