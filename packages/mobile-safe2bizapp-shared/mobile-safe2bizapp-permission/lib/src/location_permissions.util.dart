import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLocationPermission {
  AppLocationPermission._();

  static Future<bool> checkLocationPermission() async {
    var locationPerm = await Permission.location.isGranted;
    return locationPerm;
  }

  static Future<bool> checkPermission() async {
    var locationWhenInUse = await Permission.locationWhenInUse.isGranted;
    var locationPerm = await Permission.location.isGranted;
    return locationWhenInUse && locationPerm;
  }

  static Future<bool> checkIfIsMocked() async {
    if (await checkPermission()) {
      var isMocked = (await Geolocator.getCurrentPosition()).isMocked;
      return isMocked;
    } else {
      return false;
    }
  }

  static Future<bool> checkServiceEnabled() async {
    var locationEnabled = await Geolocator.isLocationServiceEnabled();
    return locationEnabled;
  }

  static Future<PermissionStatus> requestPermission() async {
    if (!await checkPermission()) {
      return await Permission.locationWhenInUse.request().then((value) async =>
          value.isDenied
              ? await Permission.location.request()
              : PermissionStatus.granted);
    } else {
      return PermissionStatus.granted;
    }
  }

  static Future<PermissionStatus> requestLocationPermission() async {
    if (!await checkLocationPermission()) {
      return await Permission.location.request();
    } else {
      return PermissionStatus.granted;
    }
  }

  static Future<void> requestLocationService() async {
    await Geolocator.requestPermission();
  }
}
