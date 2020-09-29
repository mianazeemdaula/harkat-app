import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

enum LocationStatus {
  DisableService,
  EnableService,
  PermissionDenied,
  PermissionGranted
}

class LocationProvider extends ChangeNotifier {
  bool _isLocationServiceEnabled;
  LocationStatus _locationStatus;
  LocationPermission _permission;

  Position _position;
  // getters

  LocationStatus get locationStatus => _locationStatus;
  Position get position => _position;

  LocationProvider() {
    initLocationService();
  }

  initLocationService() async {
    _isLocationServiceEnabled = await isLocationServiceEnabled();
    if (!_isLocationServiceEnabled) {
      _locationStatus = LocationStatus.DisableService;
    } else {
      requestForPermission();
    }
    notifyListeners();
  }

  Future<void> requestService() async {
    await openLocationSettings();
    _isLocationServiceEnabled = await isLocationServiceEnabled();
    if (_isLocationServiceEnabled &&
        (_permission == LocationPermission.always ||
            _permission == LocationPermission.whileInUse)) {
      _locationStatus = LocationStatus.PermissionGranted;
    } else {
      _locationStatus = LocationStatus.PermissionDenied;
    }
    notifyListeners();
  }

  Future<void> requestForPermission() async {
    if (await isLocationServiceEnabled()) {
      _permission = await checkPermission();
      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        _permission = await requestPermission();
        if (_permission == LocationPermission.denied ||
            _permission == LocationPermission.deniedForever) {
          _locationStatus = LocationStatus.PermissionDenied;
        } else if (_permission == LocationPermission.always ||
            _permission == LocationPermission.whileInUse) {
          _locationStatus = LocationStatus.PermissionGranted;
          _position =
              await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        }
      } else {
        _position =
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _locationStatus = LocationStatus.PermissionGranted;
      }
      notifyListeners();
    } else {
      requestService();
    }
  }
}
