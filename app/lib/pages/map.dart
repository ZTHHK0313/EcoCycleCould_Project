import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  void updateToRecent() {
    // TODO: implement updateToRecent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Expanded(child: FlutterMap(children: []))],
    );
  }
}

