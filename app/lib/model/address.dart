abstract final class EnumeratedAddress {
  const EnumeratedAddress._();

  String get fullName;
}

enum HKRegion implements EnumeratedAddress {
  hk("Hong Kong Island"),
  kl("Kowloon"),
  nt("New Territories");

  @override
  final String fullName;

  const HKRegion(this.fullName);
}

enum HKDistrict implements EnumeratedAddress {
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

final class AddressInfo {
  final String address;
  final HKDistrict district;

  const AddressInfo(this.address, this.district);

  HKRegion get region => district.region;

  String get completedAddress =>
      "$address, ${district.fullName}, ${region.fullName}";

  @override
  String toString() {
    return completedAddress;
  }
}
