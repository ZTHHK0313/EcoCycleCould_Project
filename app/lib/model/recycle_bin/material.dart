
enum RecyclableMaterial { plastic, metal, paper }

extension RecyclableMaterialDisplayNameExtension on RecyclableMaterial {
  String get displayName => "${name[0].toUpperCase()}${name.substring(1)}";
}