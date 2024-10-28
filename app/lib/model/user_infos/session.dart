import '../identifiable.dart';

final class Session implements Identifiable<String> {
  @override
  final String identifier;

  const Session(this.identifier);
}