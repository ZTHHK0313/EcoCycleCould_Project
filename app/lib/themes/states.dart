import 'package:flutter/material.dart';

final class ConstantWidgetStateProperties<T> extends WidgetStateProperty<T?> {
  static const Iterable<WidgetState> _selectingState = [
    WidgetState.focused,
    WidgetState.hovered
  ];

  static const Iterable<WidgetState> _disabledState = [WidgetState.disabled];

  static const Iterable<WidgetState> _errorState = [WidgetState.error];

  final T? defaultValue;
  final T? selecting;
  final T? disabled;
  final T? error;
  final bool useDefaultIfAbsent;

  ConstantWidgetStateProperties(this.defaultValue,
      {this.selecting,
      this.disabled,
      this.error,
      this.useDefaultIfAbsent = false});

  static bool _onActivateState(
          Set<WidgetState> states, Iterable<WidgetState> condition) =>
      condition.any((condState) => states.contains(condState));

  @override
  T? resolve(Set<WidgetState> states) {
    if (_onActivateState(states, _selectingState) &&
        (selecting != null || !useDefaultIfAbsent)) {
      return selecting;
    } else if (_onActivateState(states, _disabledState) &&
        (disabled != null || !useDefaultIfAbsent)) {
      return disabled;
    } else if (_onActivateState(states, _errorState) &&
        (error != null || !useDefaultIfAbsent)) {
      return error;
    }

    return defaultValue;
  }
}
