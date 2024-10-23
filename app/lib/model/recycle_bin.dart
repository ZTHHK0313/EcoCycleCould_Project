import 'dart:collection';

import 'errors.dart';

enum RecyclableMaterial { plastic, metal, paper }

final class RecycleBinRemainCapacity extends UnmodifiableMapBase<RecyclableMaterial, int> {
  final int plastic;
  final int metal;
  final int paper;

  RecycleBinRemainCapacity(this.plastic, this.metal, this.paper) {
    final invalidRemains = {
      RecyclableMaterial.plastic.name: plastic,
      RecyclableMaterial.metal.name: metal,
      RecyclableMaterial.paper.name: paper
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
  
  @override
  int? operator [](Object? key) {
    if (key is! RecyclableMaterial) {
      throw TypeError();
    }

    return switch (key) {
      RecyclableMaterial.plastic => plastic,
      RecyclableMaterial.metal => metal,
      RecyclableMaterial.paper => paper,
      /* 
        Other recycle bin material case.

        Do not remove for future implementation.
      */
      // ignore: unreachable_switch_case
      _ => null
    };
  }
  
  @override
  Iterable<RecyclableMaterial> get keys sync* {
    yield RecyclableMaterial.plastic;
    yield RecyclableMaterial.metal;
    yield RecyclableMaterial.paper;
  }
}


