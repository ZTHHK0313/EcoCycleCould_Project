import 'dart:collection';

import '../errors.dart';
import '../identifiable.dart';
import 'material.dart';

final class RemainCapacity extends UnmodifiableMapBase<RecyclableMaterial, int>
    implements Identifiable<int> {
  final int recycleBinId;
  final int _plastic;
  final int _metal;
  final int _paper;

  RemainCapacity(this.recycleBinId, int plastic, int metal, int paper)
      : _plastic = plastic,
        _metal = metal,
        _paper = paper {
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
      RecyclableMaterial.plastic => _plastic,
      RecyclableMaterial.metal => _metal,
      RecyclableMaterial.paper => _paper,
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

  @override
  int get identifier => recycleBinId;
}
