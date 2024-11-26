import 'dart:convert';

import 'package:latlong2/latlong.dart';

import '../model/address.dart';
import '../model/recycle_bin/capacity.dart';
import '../model/recycle_bin/location.dart';
import '../model/user_infos/user.dart';
import '../net/rest_client.dart';
import '../net/url.dart';

typedef RecycleBinTuple = (RecycleBinLocation, RemainCapacity);

Future<List<RecycleBinLocation>> loadAllRecycleBinsLocation() async {
  return [
    RecycleBinLocation(
        0,
        AddressInfo(
            "3/F, Yeung Kin Man Academic Building (AC1), City University of Hong Kong",
            HKDistrict.ssp),
        LatLng(22.335833, 114.17344)),
    RecycleBinLocation(
        1,
        AddressInfo("Kornhill Plaza South (Near Exit C, Tai Koo station)",
            HKDistrict.e),
        LatLng(22.284280, 114.216613)),
    RecycleBinLocation(
        2,
        AddressInfo("G/F, Mikiki (Near Prince Edward Rd. E. enterence)",
            HKDistrict.wts),
        LatLng(22.333339, 114.196761)),
    RecycleBinLocation(
        3,
        AddressInfo("\"Free Space\", Yue Man Square", HKDistrict.kt),
        LatLng(22.313507, 114.224481)),
    RecycleBinLocation(
        4,
        AddressInfo(
            "Tsuen Wan Ferry Pair (Near Exit D, Tsuen Wan West station)",
            HKDistrict.tw),
        LatLng(22.366703, 114.110692)),
  ];
}

List<List<bool>> _usrsFavState = [
  for (int i = 0; i < 2; i++) [false, false, false, false, false]
];

bool recycleBinBookmarked(User usr, RecycleBinLocation loc) {
  final List<bool> usrFavState = _usrsFavState[usr.identifier];

  return usrFavState[loc.identifier];
}

Future<List<RecycleBinTuple>> loadBookmarkedRecycleBins(User usr) async {
  final favLocs = await loadAllRecycleBinsLocation()
      .then((locs) => locs.where((loc) => recycleBinBookmarked(usr, loc)));

  final List<RecycleBinTuple> tmp = [];
  final List<Map<String, dynamic>> rbCap = List.from(await getAllRawRecycleBinCapacity(), growable: false);

  for (RecycleBinLocation rbLoc in favLocs) {
    final favCap = rbCap[rbLoc.identifier]["capacity"];

    tmp.add((
      rbLoc,
      RemainCapacity(
          rbLoc.identifier, favCap["plastic"], favCap["metal"], favCap["paper"])
    ));
  }

  return tmp;
}

enum AlterRecycleBinBookmarkAction { add, remove }

Future<bool> alterRecycleBinBookmark(User usr, RecycleBinLocation rbLoc,
    AlterRecycleBinBookmarkAction action) async {
  final List<bool> usrFavState = _usrsFavState[usr.identifier];

  usrFavState[rbLoc.identifier] = switch (action) {
    AlterRecycleBinBookmarkAction.add => true,
    AlterRecycleBinBookmarkAction.remove => false
  };

  return true;
}

Future<List<dynamic>> getAllRawRecycleBinCapacity() async {
  final RestClient c = RestClient();

  try {
    return await c
        .get(APIPath.capacity)
        .then((resp) => jsonDecode(resp.body)["df"]);
  } finally {
    c.close();
  }
}
