import 'dart:async';

import 'package:geolocator/geolocator.dart';

class AppPosition {
  AppPosition();
  static final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  static Stream<Position> get startTracking async* {
    yield* Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
