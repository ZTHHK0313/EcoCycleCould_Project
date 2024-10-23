import 'package:meta/meta.dart';

class OutOfBoundError extends ArgumentError {
  final num minimum;
  final num maximum;

  OutOfBoundError(num value,
      {String? name,
      String? message,
      this.minimum = double.negativeInfinity,
      this.maximum = double.infinity})
      : super.value(value, name, message);

  @protected
  @mustBeOverridden
  String get defaultMessage => "This value is not in accepted range.";

  @override
  String toString() {
    bool noMsg = message == null;
    if (message is String) {
      noMsg = message.isEmpty;
    }

    StringBuffer buf = StringBuffer();

    buf
      ..write("OutOfBoundError: ")
      ..writeln(noMsg ? defaultMessage : message)
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
