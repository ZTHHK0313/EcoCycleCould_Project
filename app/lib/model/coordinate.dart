import 'errors.dart';

const double _maxLatitude = 180;
const double _minLatitude = -180;
const double _maxLongitude = 90;
const double _minLongitude = -90;

extension type const Coordinate._((double, double) _loc) {
  static const Coordinate hkCenter = Coordinate._((22.3526404, 113.9628891));
  static const Coordinate cityU = Coordinate._((22.347776, 114.180096));

  factory Coordinate(double latitude, double longitude) {
    if (latitude > _maxLatitude || latitude < _minLatitude) {
      throw OutOfBoundError(latitude,
          name: "latitude",
          message: "Invalid latitude range.",
          minimum: _minLatitude,
          maximum: _maxLatitude);
    } else if (longitude > _maxLongitude || longitude < _minLongitude) {
      throw OutOfBoundError(longitude,
          name: "longitude",
          message: "Invalid longitude range.",
          minimum: _minLongitude,
          maximum: _maxLongitude);
    }

    return Coordinate._((latitude, longitude));
  }

  double get latitude => _loc.$1;

  double get longitude => _loc.$2;
}
