import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import '../model/recycle_bin/location.dart';
import '../model/geographic/coordinate.dart';
import '../widgets/state_updater.dart';

final class RecycleBinMapPage extends StatefulWidget {
  const RecycleBinMapPage({super.key});

  @override
  State<RecycleBinMapPage> createState() {
    return _RecycleBinMapPageState();
  }
}

class _RecycleBinMapPageState extends State<RecycleBinMapPage> {
  late final AsyncMemoizer<Coordinate> _coordinateMemorizer;
  late final GlobalKey<StateUpdater<_RecycleBinMapInterface>> _mapKey;

  @override
  void initState() {
    super.initState();
    _mapKey = GlobalKey();
    _coordinateMemorizer = AsyncMemoizer();
  }

  bool get _isKeyAttachedState => _mapKey.currentState != null;

  Future<Coordinate> _getGPSLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text(
                "To show recycle bin in surrounded area, please enable location service.")));
      }

      return Coordinate.hkCenter;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } catch (err) {
      // Just return default coordinate if throw during request permission.
    }

    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        Position pos = await Geolocator.getCurrentPosition();

        return Coordinate(pos.latitude, pos.longitude);
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      case LocationPermission.unableToDetermine:
        break;
    }

    return Coordinate.hkCenter;
  }

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
            child: FutureBuilder<Coordinate>(
                future: _coordinateMemorizer.runOnce(_getGPSLocation),
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
  final Coordinate coordinate;

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
