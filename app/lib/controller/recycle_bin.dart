import 'package:latlong2/latlong.dart';

import '../model/address.dart';
import '../model/recycle_bin/capacity.dart';
import '../model/recycle_bin/location.dart';
import '../model/user_infos/user.dart';

typedef RecycleBinTuple = (RecycleBinLocation, RemainCapacity);

Future<List<RecycleBinLocation>> loadAllRecycleBinsLocation() async {
  return [
    RecycleBinLocation(
        1, AddressInfo("adsadsa", HKDistrict.kt), LatLng(22.2244, 114.123)),
    RecycleBinLocation(
        2, AddressInfo("ASDA", HKDistrict.e), LatLng(22.22222, 114))
  ];
}

Future<List<RecycleBinTuple>> loadBookmarkedRecycleBins(
    User usr) async {
  return [
    (
      RecycleBinLocation(
          1, AddressInfo("adsadsa", HKDistrict.kt), LatLng(23, 114.3)),
      RemainCapacity(1, 35, 12, 89)
    )
  ];
}

enum AlterRecycleBinBookmarkAction { add, remove }

Future<bool> alterRecycleBinBookmark(User usr, RecycleBinLocation rbLoc,
    AlterRecycleBinBookmarkAction action) async {
  return true;
}
