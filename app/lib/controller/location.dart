import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const LatLng _hkCenter = LatLng(22.3526404, 113.9628891);

Future<bool> locationServiceAvailable() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return false;
  }

  switch (await Geolocator.checkPermission()) {
    case LocationPermission.whileInUse:
    case LocationPermission.always:
      return true;
    default:
      return false;
  }
}

Future<LatLng> obtainCurrentLocation([LatLng fallback = _hkCenter]) async {
  if (!await locationServiceAvailable()) {
    return fallback;
  }

  Position gpsLoc = await Geolocator.getCurrentPosition();

  return LatLng(gpsLoc.latitude, gpsLoc.longitude);
}
