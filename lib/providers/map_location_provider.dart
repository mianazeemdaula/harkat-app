import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/model/address_from_geocode.dart';
import 'package:http/http.dart' as http;

class MapLocationProvider with ChangeNotifier {
  AddressFromGeoCode _addressFromGeoCode;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};

  AddressFromGeoCode get addressFromGeoCode => _addressFromGeoCode;
  Set get markers => Set<Marker>.from(_markers.values);
  Set get polyLines => Set<Polyline>.from(_polyLines.values);

  Future<void> addMarker(
      {String id, LatLng position, String icon, Function onTap}) async {
    MarkerId _markerId = MarkerId(id);
    BitmapDescriptor _icon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, icon);
    _markers[_markerId] = _markers.containsKey(_markerId)
        ? _markers[_markerId].copyWith(
            positionParam: position,
            iconParam: _icon,
            onTapParam: onTap,
          )
        : Marker(
            markerId: _markerId,
            onTap: onTap,
            icon: _icon,
            position: position,
          );
    notifyListeners();
  }

  Future<void> removeMarker(String id) async {
    MarkerId _markerId = MarkerId(id);
    if (_markers.containsKey(_markerId)) {
      _markers.keys.toList().remove(_markerId);
    }
    notifyListeners();
  }

  Future<void> getAddressFromLocation(double lat, double lng) async {
    _addressFromGeoCode = null;
    notifyListeners();
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapApi";
    try {
      http.Response _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _result = jsonDecode(_response.body);
        if (_result.containsKey('results')) {
          if (_result['results'].containsKey('formatted_address')) {
            _addressFromGeoCode = AddressFromGeoCode(
              formattedAddress: _result['results']['formatted_address'],
              latitude: lat,
              longitude: lng,
            );
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print("$e");
    }
  }
}
