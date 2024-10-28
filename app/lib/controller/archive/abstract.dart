import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

typedef OnRetriveCallback<T extends Object> = Future<T> Function(Database db);
typedef OnStoreCallback<T extends Object> = Future<void> Function(
    Database db, T data);

abstract base class DataArchiver<T extends Object> {
  final String name;
  final OnRetriveCallback<T> _onRetrive;
  final OnStoreCallback<T> _onStore;

  late final Future<Database> _db;

  DataArchiver(this.name,
      {required OnRetriveCallback<T> onRetrive,
      required OnStoreCallback<T> onStore})
      : _onRetrive = onRetrive,
        _onStore = onStore {
    _db = getApplicationSupportDirectory()
        .then((supportDir) async => await supportDir.create(recursive: true))
        .then((supportDir) => p.join(supportDir.path, '$name.db'))
        .then((dbPath) => databaseFactoryIo.openDatabase(dbPath));
  }

  Future<T> retrive() async {
    final Database currentDb = await _db;

    throw UnimplementedError();
  }

  Future<void> close() async {
    final Database currentDb = await _db;
    
    return currentDb.close();
  }
}
