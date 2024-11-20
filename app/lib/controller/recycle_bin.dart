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
        1,
        AddressInfo("3/F, YEUNG (AC1), City U", HKDistrict.ssp),
        LatLng(22.3355501, 114.1719903)),
  ];
}

List<Map<int, bool>> _usrsFavState = [
  {1: false},
  {1: false}
];

bool recycleBinBookmarked(User usr, RecycleBinLocation loc) {
  final Map<int, bool> usrFavState = _usrsFavState[usr.identifier];

  return usrFavState[loc.identifier] ?? false;
}

Future<List<RecycleBinTuple>> loadBookmarkedRecycleBins(User usr) async {
  final favLocs = await loadAllRecycleBinsLocation()
      .then((locs) => locs.where((loc) => recycleBinBookmarked(usr, loc)));

  final List<RecycleBinTuple> tmp = [];
  final Map<String, dynamic> rbCap = await getAllRawRecycleBinCapacity();

  if (favLocs.where((loc) => loc.identifier == rbCap["id"]).isNotEmpty) {
    final currentLoc = favLocs.first;
    final capacity = rbCap["capacity"];

    tmp.add((
      currentLoc,
      RemainCapacity(currentLoc.identifier, capacity["plastic"], capacity["metal"],
          capacity["paper"])
    ));
  }

  return tmp;
}

enum AlterRecycleBinBookmarkAction { add, remove }

Future<bool> alterRecycleBinBookmark(User usr, RecycleBinLocation rbLoc,
    AlterRecycleBinBookmarkAction action) async {
  final Map<int, bool> usrFavState = _usrsFavState[usr.identifier];

  usrFavState[rbLoc.identifier] = switch (action) {
    AlterRecycleBinBookmarkAction.add => true,
    AlterRecycleBinBookmarkAction.remove => false
  };

  return true;
}

Future<Map<String, dynamic>> getAllRawRecycleBinCapacity() async {
  final RestClient c = RestClient();

  try {
    return await c.get(APIPath.capacity).then((resp) => jsonDecode(resp.body));
  } finally {
    c.close();
  }
}
