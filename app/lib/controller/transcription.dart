import '../controller/user.dart';
import '../model/recycle_bin/material.dart';
import '../model/user_infos/points.dart';
import '../model/user_infos/user.dart';

typedef PointsTranscriptionsPage = ({
  List<PointsTranscription> transcriptions,
  bool hasNext
});

Future<PointsTranscriptionsPage> loadPointsTranscription(
    User usr, int page) async {
  assert(page > 0);

  final rawData = await getRawUserData(usr);

  Iterable<(RecyclableMaterial, int, int)> interaction =
      (rawData["Interactoins"] as List<Map<String, dynamic>>).map((i) => (
            switch (i["waste_type"]) {
              0 => RecyclableMaterial.metal,
              1 => RecyclableMaterial.paper,
              2 => RecyclableMaterial.plastic,
              _ => throw UnsupportedError(
                  "Unknown enumerated value ${i["waste_type"]}")
            },
            rawData["pts"],
            rawData["time"]
          ));

  Iterable<int> timeGroup = interaction.map((t) => t.$3).toSet().toList()
    ..sort();

  return (
    transcriptions: <PointsTranscription>[
      for (int time in timeGroup)
        PointsTranscription(
            interaction.where((t) => t.$3 == time).map((t) {
              final (material, point, _) = t;

              return PointsActivityTuple(point, "Recycling ${material.name}");
            }),
            DateTime.fromMillisecondsSinceEpoch(time))
    ],
    hasNext: false
  );
}

Future<int> getUserTotalPts(User usr) async {
  final rawData = await getRawUserData(usr);

  return rawData["pts"];
}
