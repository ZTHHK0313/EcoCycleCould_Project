import '../geographic/address.dart';
import '../geographic/coordinate.dart';
import '../identifiable.dart';

final class RecycleBinLocation implements Identifiable<int> {
  @override
  final int identifier;
  final AddressInfo address;
  final Coordinate coordinate;

  RecycleBinLocation(this.identifier, this.address, this.coordinate);
}