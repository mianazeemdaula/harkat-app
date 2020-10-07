import 'dart:async';
import 'package:location/location.dart';

class LocationService {
  LocationData _currentLocation;

  StreamController<LocationData> _locationController =
      StreamController<LocationData>();

  Stream<LocationData> get locationStream => _locationController.stream;

  var location = Location();

  LocationService() {
    try {
      location.requestPermission().then((permission) {
        if (permission == PermissionStatus.granted) {
          location.onLocationChanged.listen((locationData) {
            if (locationData != null) {
              _locationController.add(locationData);
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

  Future<LocationData> getLocation() async {
    try {
      _currentLocation = await location.getLocation();
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}
