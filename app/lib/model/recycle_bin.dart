import 'dart:collection';

import 'errors.dart';

enum RecyclableMaterial { plastic, metal, paper }

final class RecycleBinCapacity {
  final ({int plastic, int metal, int paper}) remains;

  RecycleBinCapacity(this.remains) {
    final invalidRemains = {
      RecyclableMaterial.plastic.name: remains.plastic,
      RecyclableMaterial.metal.name: remains.metal,
      RecyclableMaterial.paper.name: remains.paper
    }.entries.where((e) => e.value > 100 || e.value < 0);

    if (invalidRemains.isNotEmpty) {
      final appliedEntry = invalidRemains.first;

      throw OutOfBoundError(appliedEntry.value,
          name: "remains.${appliedEntry.key}",
          message: "Invalid percentage range.",
          minimum: 0,
          maximum: 100);
    }
  }

  Map<RecyclableMaterial, int> toMap() {
    final LinkedHashMap<RecyclableMaterial, int> data = LinkedHashMap(
        equals: (m1, m2) => m1.index == m2.index, hashCode: (m) => m.index)
      ..addEntries([
        MapEntry(RecyclableMaterial.plastic, remains.plastic),
        MapEntry(RecyclableMaterial.metal, remains.metal),
        MapEntry(RecyclableMaterial.paper, remains.paper)
      ]);

    return UnmodifiableMapView(data);
  }
}
