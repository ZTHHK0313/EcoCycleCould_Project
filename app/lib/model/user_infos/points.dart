import '../errors.dart';

/// [int]-based type declaration to indicate number of items are applied.
extension type Quantity._(int _value) implements int {
  /// Construct new [Quantity] with applied [value].
  /// 
  /// The value must be positive and [OutOfBoundError] thrown otherwise.
  factory Quantity(int value) {
    if (value <= 0) {
      throw OutOfBoundError(value,
          name: "value",
          message: "Quantity must be positive integer.",
          minimum: 1);
    }

    return Quantity._(value);
  }
}

/// A tuple that recording each activities in [PointsTranscription].
final class PointsActivityTuple {
  /// Rewarded points when this activity occured.
  final int points;

  /// Number of this activity occured repeatedly.
  /// 
  /// If no specified, it applys `1` automatically.
  final Quantity quantity;

  /// Textual information of this activity.
  final String description;

  PointsActivityTuple(this.points, this.description, [int quantity = 1])
      : quantity = Quantity(quantity);

  /// Compute net points of this activity.
  int get netPoints => points * quantity;

  @override
  String toString() {
    return "PointsActivityTuple(points: $points, quantity: $quantity, description: $description)";
  }
}

/// A statement for recording any modification of the points with given [activities]
/// as well as [timestamp].
final class PointsTranscription {
  /// Records every activities made in this transcription.
  /// 
  /// Every [PointsActivityTuple.points] should be either all non-positive (as gaining points)
  /// or all non-negative (as deducting points). Coexisting positive and negaitve points
  /// will cause [ArgumentError] thrown.
  final List<PointsActivityTuple> activities;

  /// The time when this transcription made.
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

  /// Sum all [PointsActivityTuple.netPoints] to obtain total points rewarded or
  /// deducted for this transcription.
  int get totalPoints =>
      activities.map((e) => e.netPoints).reduce((value, e) => value += e);

  @override
  String toString() {
    return "PointsTranscription($timestamp)$activities";
  }
}
