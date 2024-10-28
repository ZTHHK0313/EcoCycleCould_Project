import '../identifiable.dart';

final class Session implements Identifiable<String> {
  @override
  final String identifier;
  final DateTime createAt;

  Session(this.identifier, [DateTime? createAt])
      : createAt = createAt ?? DateTime.now();
}
