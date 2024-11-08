/// An interface that the implemented classes can be represents unique result
/// by [identifier].
///
/// The generic type [T], which used for [identifier] should be primitive data type
/// in Dart with readability (i.e. [int], [String]).
abstract interface class Identifiable<T extends Object> {
  const Identifiable._();

  /// An unique value represents among data set in [Identifiable].
  T get identifier;
}
