import 'package:flutter/material.dart';

import '../model/recycle_bin/capacity.dart';
import '../themes/colours.dart' hide PointsRewardedColor;

extension _RecyclableMaterialColorBinder on RecyclableMaterial {
  Color get color => switch (this) {
        RecyclableMaterial.plastic => RecycleBinColor.plastic,
        RecyclableMaterial.metal => RecycleBinColor.metal,
        RecyclableMaterial.paper => RecycleBinColor.paper
      };
}

// TODO: Consider uses stream based
/*
final class RecycleBinStatusInfo extends StatelessWidget {
  final RecycleBin recycleBin;

  const RecycleBinStatusInfo(this.recycleBin, {super.key});

  @override
  Widget build(BuildContext context) {
    const double infoPadding = 4;
    return Card(
      color: ecoGreen[50],
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(recycleBin.location.completedAddress)),
          const Divider(),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: infoPadding),
              child: Text("Remaining capacity: ")),
          ...recycleBin.capacity.entries.map<Widget>((entry) {
            String displayName = entry.key.name;
            displayName =
                displayName[0].toUpperCase() + displayName.substring(1);

            return Padding(
                padding: const EdgeInsets.symmetric(vertical: infoPadding),
                child: ListTile(
                    tileColor: entry.key.color,
                    title: Text(displayName),
                    trailing: Text("${entry.value}%")));
          })
        ],
      ),
    );
  }
}
*/