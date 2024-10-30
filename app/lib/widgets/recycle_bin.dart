import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../model/recycle_bin/location.dart';
import '../model/recycle_bin/capacity.dart';
import '../model/recycle_bin/material.dart';
import '../themes/colours.dart' hide PointsRewardedColor;
import 'state_updater.dart';

extension _RecyclableMaterialColorBinder on RecyclableMaterial {
  Color get color => switch (this) {
        RecyclableMaterial.plastic => RecycleBinColor.plastic,
        RecyclableMaterial.metal => RecycleBinColor.metal,
        RecyclableMaterial.paper => RecycleBinColor.paper
      };
}

final class RecycleBinStatusInfo extends StatefulWidget {
  final int recycleBinId;

  const RecycleBinStatusInfo(this.recycleBinId,
      {required GlobalKey<StateUpdater<RecycleBinStatusInfo>> super.key});

  @override
  State<RecycleBinStatusInfo> createState() {
    return _RecycleBinStatusInfoState();
  }
}

final class _RecycleBinStatusInfoState extends State<RecycleBinStatusInfo>
    with StateUpdater<RecycleBinStatusInfo> {
  late final AsyncMemoizer<RecycleBinLocation> _locationMemorizer;
  late Future<RemainCapacity> _recentCapacity;

  Future<RecycleBinLocation> _getLocation() async {
    throw UnimplementedError("Wait API implemented");
  }

  Future<RemainCapacity> _getCurrentCapacity() async {
    throw UnimplementedError("API implementation still in progress");
  }

  void _loadRecentCapacity() {
    _recentCapacity = _getCurrentCapacity();
  }

  @override
  void updateToRecent() {
    setState(() {
      _loadRecentCapacity();
    });
  }

  @override
  void initState() {
    super.initState();
    _locationMemorizer = AsyncMemoizer();
    _loadRecentCapacity();
  }

  FutureBuilder<RecycleBinLocation> _buildLocation(BuildContext context) {
    return FutureBuilder(
        future: _locationMemorizer.runOnce(_getLocation),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Text(snapshot.data!.address.completedAddress);
              } else if (snapshot.hasError) {
                return const Text("(Data unavailable)");
              }
            default:
              break;
          }

          return const SizedBox();
        });
  }

  FutureBuilder<RemainCapacity> _buildRemainCapacity(BuildContext context) {
    return FutureBuilder(
        future: _recentCapacity,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Column(
                  children: <ListTile>[
                    for (MapEntry<RecyclableMaterial, int> entry
                        in snapshot.data!.entries)
                      ListTile(
                          tileColor: entry.key.color,
                          title: Text(entry.key.displayName),
                          trailing: Text("${entry.value}%"))
                  ]
                      .map((listTile) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: listTile))
                      .toList(growable: false),
                );
              } else if (snapshot.hasError) {
                return const SizedBox.square(
                    dimension: 200,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.error_outline, size: 36)),
                          Text("Data temproary unavailable",
                              textAlign: TextAlign.center)
                        ]));
              }
            default:
              break;
          }

          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ecoGreen[100],
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: _buildLocation(context)),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Center(child: _buildLocation(context)))
          ],
        ));
  }
}
