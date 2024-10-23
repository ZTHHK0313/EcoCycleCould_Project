import 'errors.dart';

extension type Quantity._(int _value) implements int {
  Quantity(int value) : _value = value {
    if (value <= 0) {
      throw OutOfBoundError(value,
          name: "value",
          message: "Quantity must be positive integer.",
          minimum: 1);
    }
  }

  Quantity operator +(num other) {
    if (other is Quantity) {
      return Quantity(_value + other._value);
    } else if (other is int) {
      return Quantity(_value + other);
    }

    throw TypeError();
  }

  Quantity operator -(num other) {
    if (other is Quantity) {
      return Quantity(_value - other._value);
    } else if (other is int) {
      return Quantity(_value - other);
    }

    throw TypeError();
  }
}

final class PointsActivityTuple {
  final int points;
  final Quantity quantity;
  final String description;

  PointsActivityTuple(this.points, this.description, [int quantity = 1])
      : quantity = Quantity(quantity);

  int get netPoints => points * quantity;

  @override
  String toString() {
    return "PointsActivityTuple(points: $points, quantity: $quantity, description: $description)";
  }
}

final class PointsTranscription {
  final List<PointsActivityTuple> activities;
  final DateTime timestamp;

  PointsTranscription(Iterable<PointsActivityTuple> activities, this.timestamp)
      : activities = List.unmodifiable(activities) {
    if (!_isSamePointSign(activities)) {
      throw ArgumentError.value(activities, "activities",
          "Positive and negative points should not be coexisted.");
    }
  }

  static bool _isSamePointSign(Iterable<PointsActivityTuple> activities) {
    return activities.every((e) => e.points >= 0) ||
        activities.every((e) => e.points <= 0);
  }

  int get totalPoints =>
      activities.map((e) => e.netPoints).reduce((value, e) => value += e);

  @override
  String toString() {
    return "PointsTranscription($timestamp)$activities";
  }
}
