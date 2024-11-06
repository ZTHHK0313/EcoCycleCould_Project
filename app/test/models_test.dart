import 'package:eco_cycle_cloud/model/errors.dart';
import 'package:eco_cycle_cloud/model/address.dart';
import 'package:eco_cycle_cloud/model/recycle_bin/material.dart';
import 'package:eco_cycle_cloud/model/user_infos/points.dart';
import 'package:eco_cycle_cloud/model/recycle_bin/capacity.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

const LatLng cityULoc = LatLng(22.347776, 114.180096);

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

    test("location information", () {
      const AddressInfo mockLocInfo =
          AddressInfo("AC1, City U", HKDistrict.ssp, cityULoc);

      expect(mockLocInfo.region, equals(HKRegion.kl));
      expect(mockLocInfo.completedAddress, equals("AC1, City U, Kowloon"));
    });
  });

  group("Recycle bin capacity", () {
    test("construction", () {
      expect(() => RemainCapacity(-1, 555, 99, 99), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 99, 913, 99), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 99, 99, 333), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, -1, 32, 42), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 9, 23, -54), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 50, -87, 21), throwsOutOfBoundError);
      expect(() => RemainCapacity(-1, 100, 100, 100), returnsNormally);
      expect(() => RemainCapacity(-1, 0, 0, 0), returnsNormally);
    });

    test("structure", () {
      final RemainCapacity mockCapacity = RemainCapacity(-1, 34, 67, 89);

      expect(mockCapacity, equals({
        RecyclableMaterial.plastic: 34,
        RecyclableMaterial.metal: 67,
        RecyclableMaterial.paper: 89
      }, 3));
    });
  });
}
