import 'dart:async';

import 'package:meta/meta.dart';

import '../../model/identifiable.dart';

abstract final class FetchBase<I extends Object, T> {
  const FetchBase._();

  I get identifier;

  T fetch();
}

abstract base class FetchGetter<I extends Object, T extends Identifiable<T>>
    implements FetchBase<I, Future<T>> {
  @override
  final I identifier;

  FetchGetter(this.identifier);
}

abstract base class FetchSetter<I extends Object>
    implements FetchBase<I, Future<void>> {
  @override
  final I identifier;

  @protected
  final Map<String, dynamic> params;

  FetchSetter(this.identifier, Map<String, dynamic> params)
      : params = Map.unmodifiable(params);
}
