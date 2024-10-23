import 'package:eco_cycle_cloud/model/errors.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eco_cycle_cloud/model/points.dart';

final throwsOutOfBoundError = throwsA(isA<OutOfBoundError>());

void main() {
  test("Quantity extension", () {
    expect(() => Quantity(-2), throwsOutOfBoundError);
    expect(Quantity(3) + 4, equals(Quantity(7)));
  });

  group("Pointing model test", () {
    test("activity", () {
      expect(() => PointsActivityTuple(5, "Negative qty", -2),
          throwsOutOfBoundError);
      expect(PointsActivityTuple(30, "Single qty").netPoints, equals(30));
      expect(PointsActivityTuple(15, "Multi qty", 3).netPoints, equals(45));
      expect(PointsActivityTuple(-20, "Multi qty deduct", 2).netPoints,
          equals(-40));
    });

    test("transcription", () {
      expect(
          () => PointsTranscription([
                PointsActivityTuple(5, "Sample 1"),
                PointsActivityTuple(-8, "Sample 2")
              ], DateTime.now()),
          throwsArgumentError);
    });
  });
}
