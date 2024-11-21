import 'package:meta/meta.dart';

/// Sub-class of [ArgumentError] that the given value does not in
/// between [minimum] and [maximum] as well as [double.nan] is
/// applied.
class OutOfBoundError extends ArgumentError {
  /// Accepted minimum value in the boundary.
  final num minimum;

  /// Accepted maximum value in the boundary.
  final num maximum;

  OutOfBoundError(num value,
      {String? name,
      String? message,
      this.minimum = double.negativeInfinity,
      this.maximum = double.infinity})
      : super.value(value, name, message);

  /// A default message when the provide [message] is absent.
  @protected
  @mustBeOverridden
  String get defaultMessage => "This value is not in accepted range.";

  @override
  String toString() {
    StringBuffer buf = StringBuffer();

    buf
      ..write("OutOfBoundError: ")
      ..writeln(message ?? defaultMessage)
      ..write("Applied value: ")
      ..write(invalidValue);

    if (name != null) {
      buf.writeln(" (at $name)");
    }

    buf
      ..write("Value boundary: ")
      ..write(minimum)
      ..write(" <= <value> <= ")
      ..writeln(maximum);

    return buf.toString();
  }
}

class UserLogoutException implements Exception {
  const UserLogoutException();

  @override
  String toString() {
    return "Current user is logging out.";
  }
}
