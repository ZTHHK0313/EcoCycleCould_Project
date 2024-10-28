import 'coordinate.dart';

abstract final class EnumeratedLocation {
  const EnumeratedLocation._();

  String get fullName;
}

enum HKRegion implements EnumeratedLocation {
  hk("Hong Kong Island"),
  kl("Kowloon"),
  nt("New Territories");

  @override
  final String fullName;

  const HKRegion(this.fullName);
}

enum HKDistrict implements EnumeratedLocation {
  cw("Central and Western", HKRegion.hk),
  wc("Wan Chai", HKRegion.hk),
  e("Eastern", HKRegion.hk),
  s("Southern", HKRegion.hk),
  ytm("Yau Tsim Mong", HKRegion.kl),
  ssp("Sham Shui Po", HKRegion.kl),
  kc("Kowloon City", HKRegion.kl),
  wts("Wong Tai Sin", HKRegion.kl),
  kt("Kwun Tong", HKRegion.kl),
  kts("Kwai Tsing", HKRegion.nt),
  tw("Tsuen Wan", HKRegion.nt),
  tm("Tuen Mun", HKRegion.nt),
  yl("Yuen Long", HKRegion.nt),
  n("North", HKRegion.nt),
  tp("Tai Po", HKRegion.nt),
  st("Sha Tin", HKRegion.nt),
  sk("Sai Kung", HKRegion.nt),
  i("Island", HKRegion.nt);

  @override
  final String fullName;

  final HKRegion region;

  const HKDistrict(this.fullName, this.region);
}

final class LocationInfo {
  final String address;
  final HKDistrict district;
  final Coordinate coordinate;

  const LocationInfo(this.address, this.district, this.coordinate);

  HKRegion get region => district.region;

  String get completedAddress =>
      "$address, ${region.fullName}";

  @override
  String toString() {
    StringBuffer buf = StringBuffer();

    final lat = coordinate.latitude;
    final long = coordinate.longitude;

    buf.write(completedAddress);

    const int degCode = 0xB0;

    buf
      ..write(" (")
      ..write(lat.abs())
      ..writeCharCode(degCode);

    if (lat > 0) {
      buf.write("N");
    } else if (lat < 0) {
      buf.write("S");
    }

    buf
      ..write(long.abs())
      ..writeCharCode(degCode);

    if (long > 0) {
      buf.write("E");
    } else if (long < 0) {
      buf.write("W");
    }

    buf.write(")");

    return buf.toString();
  }
}
