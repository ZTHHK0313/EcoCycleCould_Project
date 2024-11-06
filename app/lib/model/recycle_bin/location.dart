import 'package:latlong2/latlong.dart';

import '../address.dart';
import '../identifiable.dart';

final class RecycleBinLocation implements Identifiable<int> {
  @override
  final int identifier;
  final AddressInfo address;
  final LatLng coordinate;

  RecycleBinLocation(this.identifier, this.address, this.coordinate);
}
