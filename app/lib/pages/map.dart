import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/address.dart';
import '../model/user_infos/user.dart';
import '../model/recycle_bin/location.dart';
import '../widgets/state_updater.dart';
import '../controller/location.dart';

final class RecycleBinMapPage extends StatefulWidget {
  const RecycleBinMapPage({super.key});

  @override
  State<RecycleBinMapPage> createState() {
    return _RecycleBinMapPageState();
  }
}

class _RecycleBinMapPageState extends State<RecycleBinMapPage> {
  late final AsyncMemoizer<LatLng> _coordinateMemorizer;
  late final GlobalKey<StateUpdater<_RecycleBinMapInterface>> _mapKey;

  @override
  void initState() {
    super.initState();
    _mapKey = GlobalKey();
    _coordinateMemorizer = AsyncMemoizer();
  }

  bool get _isKeyAttachedState => _mapKey.currentState != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Find recycle bin"), actions: <IconButton>[
          IconButton(
              onPressed: _isKeyAttachedState
                  ? _mapKey.currentState!.updateToRecent
                  : null,
              icon: const Icon(Icons.refresh))
        ]),
        body: SafeArea(
            child: FutureBuilder<LatLng>(
                future: _coordinateMemorizer.runOnce(obtainCurrentLocation),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return _RecycleBinMapInterface(snapshot.data!,
                            key: _mapKey);
                      }

                    // It's error-free that no error widget required.
                    default:
                      break;
                  }

                  return const SizedBox();
                })));
  }
}

final class _RecycleBinMapInterface extends StatefulWidget {
  final LatLng coordinate;

  _RecycleBinMapInterface(this.coordinate,
      {required GlobalKey<StateUpdater<_RecycleBinMapInterface>> key});

  @override
  State<_RecycleBinMapInterface> createState() {
    return _RecycleBinMapInterfaceState();
  }
}

class _RecycleBinMapInterfaceState extends State<_RecycleBinMapInterface>
    with StateUpdater<_RecycleBinMapInterface> {
  late final MapController _mapCtrl;
  late Future<List<RecycleBinLocation>> _binLocations;

  @override
  void initState() {
    super.initState();
    _mapCtrl = MapController();
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  void onUpdating() {
    _binLocations = _fetchAllRecycleBinLoc();
  }

  Future<List<RecycleBinLocation>> _fetchAllRecycleBinLoc() async {
    return [
      RecycleBinLocation(
          1, AddressInfo("ASDA", HKDistrict.e), LatLng(22.22222, 114))
    ];
  }

  void _openRecycleBinDialog(BuildContext context, RecycleBinLocation rbInfo) {
    showDialog(
        context: context,
        builder: (context) {
          return _RecycleBinInfoDialog(rbInfo);
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
        future: obtainCurrentLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final currentLoc = snapshot.data!;

          return FlutterMap(
              mapController: _mapCtrl,
              options: MapOptions(
                  minZoom: 9.75,
                  maxZoom: 17,
                  initialCenter: currentLoc,
                  cameraConstraint: CameraConstraint.contain(
                      bounds: LatLngBounds(const LatLng(22.547317, 113.801197),
                          const LatLng(22.134689, 114.460742)))),
              children: [
                TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                MarkerLayer(alignment: Alignment.center, markers: <Marker>[
                  Marker(
                      point: currentLoc,
                      alignment: Alignment.center,
                      child: const Icon(Icons.man, size: 36))
                ]),
                FutureBuilder<List<RecycleBinLocation>>(
                    future: _binLocations,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MarkerLayer(
                            alignment: Alignment.center,
                            markers: snapshot.data!
                                .map((rbInfo) => Marker(
                                    alignment: Alignment.center,
                                    point: rbInfo.coordinate,
                                    child: IconButton(
                                        onPressed: () {
                                          _openRecycleBinDialog(
                                              context, rbInfo);
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.recycle))))
                                .toList(growable: false));
                      }

                      return const SizedBox();
                    })
              ]);
        });
  }
}

final class _RecycleBinInfoDialog extends StatelessWidget {
  final RecycleBinLocation location;

  _RecycleBinInfoDialog(this.location, {super.key});

  Future<bool> _isInBookmark(User currentUser) async {
    return false;
  }

  Future<bool> _updateBookmark(
      User currentUser, RecycleBinLocation rb, bool inBookmark) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentUsr = context.read<CurrentUserManager>().current;

    return AlertDialog(
        title: Text(location.address.completedAddress),
        actions: <Widget>[
          FutureBuilder<bool>(
              future: _isInBookmark(currentUsr),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final inBookmark = snapshot.data!;

                return TextButton(
                    onPressed: () async {
                      bool performChange = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text(
                                        "Do you want to ${inBookmark ? 'remove' : 'add'} this recycle bin in your bookmark?"),
                                    actions: <TextButton>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop<bool>(context, true);
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop<bool>(context, false);
                                          },
                                          child: const Text("No"))
                                    ]);
                              }) ??
                          false;

                      if (!performChange) {
                        return;
                      }

                      if (await _updateBookmark(
                          currentUsr, location, inBookmark)) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: const Text("Update success"),
                                  actions: <TextButton>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Close"))
                                  ]);
                            }).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        showDialog<void>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: const Text("Unexpected error"),
                                  content: const Text("Try again later"),
                                  actions: <TextButton>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK"))
                                  ]);
                            });
                      }
                    },
                    child: Text(
                        inBookmark ? "Remove bookmark" : "Add to bookmark",
                        style: inBookmark
                            ? const TextStyle(color: Colors.red)
                            : null));
              }),
          TextButton(
              onPressed: () {
                Navigator.pop<void>(context);
              },
              child: const Text("Close"))
        ]);
  }
}
