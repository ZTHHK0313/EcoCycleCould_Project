import 'package:eco_cycle_cloud/model/coordinate.dart';
import 'package:eco_cycle_cloud/model/errors.dart';
import 'package:eco_cycle_cloud/model/locations.dart';
import 'package:eco_cycle_cloud/model/points.dart';
import 'package:eco_cycle_cloud/model/recycle_bin.dart';

import 'package:flutter_test/flutter_test.dart';

final throwsOutOfBoundError = throwsA(isA<OutOfBoundError>());

void main() {
  group("Pointing model", () {
    test("quantity extension", () {
      expect(() => Quantity(-2), throwsOutOfBoundError);
      expect(Quantity(3) + 4, equals(Quantity(7)));
    });

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

  group("Geographics", () {
    test("coordinate", () {
      expect(() => Coordinate(190, 23), throwsOutOfBoundError);
      expect(() => Coordinate(-181, -24), throwsOutOfBoundError);
      expect(() => Coordinate(22, 91), throwsOutOfBoundError);
      expect(() => Coordinate(-64, -120), throwsOutOfBoundError);
      expect(() => Coordinate(0, 0), returnsNormally);
    });

    test("location information", () {
      const LocationInfo mockLocInfo =
          LocationInfo("AC1, City U", HKDistrict.ssp, Coordinate.cityU);

      expect(mockLocInfo.region, equals(HKRegion.kl));
      expect(mockLocInfo.completedAddress, equals("AC1, City U, Kowloon"));
    });
  });

  group("Recycle bin capacity", () {
    test("construction", () {
      expect(() => RemainCapacity(555, 99, 99), throwsOutOfBoundError);
      expect(() => RemainCapacity(99, 913, 99), throwsOutOfBoundError);
      expect(() => RemainCapacity(99, 99, 333), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 32, 42), throwsOutOfBoundError);
      expect(() => RemainCapacity(9, 23, -54), throwsOutOfBoundError);
      expect(() => RemainCapacity(50, -87, 21), throwsOutOfBoundError);
      expect(() => RemainCapacity(100, 100, 100), returnsNormally);
      expect(() => RemainCapacity(0, 0, 0), returnsNormally);
    });

    test("structure", () {
      final RemainCapacity mockCapacity = RemainCapacity(34, 67, 89);

      expect(mockCapacity, equals({
        RecyclableMaterial.plastic: 34,
        RecyclableMaterial.metal: 67,
        RecyclableMaterial.paper: 89
      }, 3));
    });
  });
}
