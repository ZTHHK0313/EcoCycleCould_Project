import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

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
  late Future<List<RecycleBinLocation>> _locations;

  @override
  void initState() {
    super.initState();
    _mapCtrl = MapController();

    obtainCurrentLocation().then((loc) {
      _mapCtrl.move(loc, 1);
    });
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  void updateToRecent() {
    setState(() {});
  }

  void _openRecycleBinDialog(BuildContext context, RecycleBinLocation rbInfo) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(rbInfo.address.completedAddress),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Add to bookmark"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: FlutterMap(children: [
          FutureBuilder(
              future: _locations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MarkerLayer(
                      markers: snapshot.data!
                          .map((rbInfo) => Marker(
                              point: rbInfo.coordinate,
                              child: IconButton(
                                  onPressed: () {
                                    _openRecycleBinDialog(context, rbInfo);
                                  },
                                  icon: const Icon(FontAwesomeIcons.recycle))))
                          .toList(growable: false));
                }

                return const SizedBox();
              })
        ]))
      ],
    );
  }
}
