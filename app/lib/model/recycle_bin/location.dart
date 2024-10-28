import '../geographic/address.dart';
import '../geographic/coordinate.dart';

final class RecycleBinLocation {
  final int id;
  final AddressInfo address;
  final Coordinate coordinate;

  RecycleBinLocation(this.id, this.address, this.coordinate);
}