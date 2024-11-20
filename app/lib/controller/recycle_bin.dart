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
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
    RecycleBinLocation(
        1,
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
    RecycleBinLocation(
        2,
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
    RecycleBinLocation(
        3,
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
    RecycleBinLocation(
        4,
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
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
  final List<dynamic> rbCap = await getAllRawRecycleBinCapacity();

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
