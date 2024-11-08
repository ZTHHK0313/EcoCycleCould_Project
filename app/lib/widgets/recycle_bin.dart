import 'package:flutter/material.dart';

import '../model/recycle_bin/location.dart';
import '../model/recycle_bin/capacity.dart';
import '../model/recycle_bin/material.dart';
import '../themes/colours.dart' hide PointsRewardedColor;

extension _RecyclableMaterialColorBinder on RecyclableMaterial {
  Color get color => switch (this) {
        RecyclableMaterial.plastic => RecycleBinColor.plastic,
        RecyclableMaterial.metal => RecycleBinColor.metal,
        RecyclableMaterial.paper => RecycleBinColor.paper
      };
}

final class RecycleBinStatusInfo extends StatelessWidget {
  final RecycleBinLocation rbLoc;
  final RemainCapacity capacity;

  const RecycleBinStatusInfo(this.rbLoc, this.capacity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ecoGreen[100],
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(rbLoc.address.completedAddress,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700))),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Divider()),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Center(child: Column(
                  children: <Widget>[
                    for (MapEntry<RecyclableMaterial, int> entry
                        in capacity.entries)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          tileColor: entry.key.color,
                          title: Text(entry.key.displayName,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500)),
                          trailing: Text("${entry.value}%",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400))))
                  ]
                )))
          ]
        ));
  }
}
