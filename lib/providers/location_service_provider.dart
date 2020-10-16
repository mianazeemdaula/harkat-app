import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum LocationStatus { NeedLocationService, PermissionDenied, PermissionGranted }

class LocationProvider extends ChangeNotifier {
  bool _isStreamLocation;
  LocationStatus _locationStatus;
  StreamController<LocationData> _locationController =
      StreamController<LocationData>.broadcast();
  LocationData _locationData;

  Stream<LocationData> get locationStream => _locationController.stream;

  bool get isSteamLocation => _isStreamLocation;
  LocationStatus get status => _locationStatus;
  LocationData get locationData => _locationData;

  var location = Location();
  LocationProvider() {
    _locationStatus = LocationStatus.NeedLocationService;
    _isStreamLocation = false;
    initLocationServices();
  }

  Future<void> initLocationServices() async {
    if (await location.serviceEnabled()) {
      requestLocationPermission();
    } else {
      bool _isEnable = await location.requestService();
      if (_isEnable) {
        requestLocationPermission();
      }
    }
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus _status = await location.hasPermission();
    if (_status == PermissionStatus.granted) {
      _isStreamLocation = true;
      _locationStatus = LocationStatus.PermissionGranted;
      setStreamEnable();
      _locationData = await location.getLocation();
    } else {
      _status = await location.requestPermission();
      if (_status == PermissionStatus.granted) {
        _locationStatus = LocationStatus.PermissionGranted;
        _isStreamLocation = true;
        setStreamEnable();
        _locationData = await location.getLocation();
      } else {
        _locationStatus = LocationStatus.PermissionDenied;
        _isStreamLocation = false;
      }
    }
    notifyListeners();
  }

  setStreamEnable() {
    try {
      location.hasPermission().then((permission) {
        if (permission == PermissionStatus.granted) {
          location.onLocationChanged.listen((locationData) {
            if (locationData != null) {
              _locationController.sink.add(locationData);
              _locationData = locationData;
              print(
                  "Location : ${locationData.latitude},${locationData.longitude}");
            }
          });
        }
      });
    } catch (e) {
      print("Error Handling Location permission");
    }
  }
}
