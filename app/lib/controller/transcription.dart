import '../model/user_infos/points.dart';
import '../model/user_infos/user.dart';

Future<(List<PointsTranscription>, bool)> loadPointsTranscription(
    User usr, int page) async {
  assert(page > 0);

  return (
    <PointsTranscription>[
      PointsTranscription(
          [PointsActivityTuple(12, "Foo"), PointsActivityTuple(56, "Bar")], DateTime(2004, 2, 1, 8, 0, 0)),
          PointsTranscription(
          [PointsActivityTuple(0, "Foo")], DateTime(2004, 2, 8, 8, 0, 0))
    ],
    false
  );
}

Future<int> getUserTotalPts(User usr) async {
  return 114514;
}
