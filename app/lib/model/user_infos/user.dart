import '../identifiable.dart';

final class User implements Identifiable<int> {
  @override
  final int identifier;
  final String name;
  
  const User(this.identifier, this.name);
}