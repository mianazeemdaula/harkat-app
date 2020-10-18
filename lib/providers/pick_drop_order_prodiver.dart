import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/model/address_from_geocode.dart';
import 'package:http/http.dart' as http;

class PickDropOrderProvider with ChangeNotifier {
  AddressFromGeoCode _pickupAddress;
  String _sendersName;
  String _sendersContat;
  AddressFromGeoCode _dropAddress;
  String _receiverName;
  String _receiverContact;
  Map<String, dynamic> _mapData;
  bool _isUiBusy = false;

  AddressFromGeoCode get pickUpAddress => _pickupAddress;
  AddressFromGeoCode get dropAddress => _dropAddress;
  String get senderName => _sendersName;
  String get senderContact => _sendersContat;
  bool get isUiBusy => _isUiBusy;

  String get receiverName => _receiverName;
  String get receiverContact => _receiverContact;

  Map<String, dynamic> get mapData => _mapData;

  // set pickUpAddress(AddressFromGeoCode address) => _pickupAddress = address;
  // set sendersName(String senderName) => _sendersName;
  // set senderContact(String senderContact) => _sendersContat;
  // set pickDropAddress(AddressFromGeoCode address) => _dropAddress = address;
  // set receiversName(String name) => _receiverName = name;
  // set receiverContact(String contact) => _receiverContact = contact;

  Future<void> setPickup(
      AddressFromGeoCode pickup, String name, String contact) async {
    _pickupAddress = pickup;
    _sendersContat = contact;
    _sendersName = name;
    notifyListeners();
  }

  Future<void> setDrop(
      AddressFromGeoCode drop, String name, String contact) async {
    _dropAddress = drop;
    _receiverName = name;
    _receiverContact = contact;
    notifyListeners();
    // buildRouteAndPrice();
  }

  Future<bool> buildRouteAndPrice() async {
    PolylinePoints polylinePoints = PolylinePoints();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //     googleMapApi,
    //     PointLatLng(_pickupAddress.latitude, _pickupAddress.longitude),
    //     PointLatLng(_dropAddress.latitude, _dropAddress.longitude),
    //     travelMode: TravelMode.driving);

    var params = {
      "origin": "${_pickupAddress.latitude},${_pickupAddress.longitude}",
      "destination": "${_dropAddress.latitude},${_dropAddress.longitude}",
      "mode": "driving",
      "avoidHighways": "false",
      "avoidFerries": "true",
      "avoidTolls": "false",
      "key": googleMapApi
    };

    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);
    var response = await http.get(uri.toString());
    if (response?.statusCode == 200) {
      _mapData = json.decode(response.body);
    }
    notifyListeners();
    return true;
  }

  Future<bool> placeOrder(
    String payemntType,
  ) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      var location_from =
          GeoPoint(_pickupAddress.latitude, _pickupAddress.longitude);
      var location_to =
          GeoPoint(_pickupAddress.latitude, _pickupAddress.longitude);
      Map<String, dynamic> _data = {
        'address_from': _pickupAddress.formattedAddress,
        'location_from': location_from,
        'address_to': _dropAddress.formattedAddress,
        'location_to': location_to,
        'amont': 0,
        'customer': FirebaseAuth.instance.currentUser.uid,
        'payment_type': payemntType,
        'sender_name': _sendersName,
        'sender_contact': _sendersContat,
        'receiver_name': _receiverName,
        'receiver_contact': _receiverContact,
        'source': 'external',
        'status': 'open',
        'date': DateTime.now(),
      };
      await FirebaseFirestore.instance.collection("orders").doc().set(_data);
      _isUiBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      Get.snackbar('Error!', '$e');
      _isUiBusy = false;
      notifyListeners();
      return false;
    }
  }
}