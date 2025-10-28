import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_livre_pam/core/sqlite/sqlite_client.dart';

import '../../testing/fakes/fake_flutter_secure_storage.dart';
import '../../testing/fakes/sqlite.dart' as sqlite;

final _getIt = GetIt.I;
Future<void> setupDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dbScript = await sqlite.dbScript;

  _getIt.registerFactory<SqliteClient>(() => sqlite.inMemoryClient(dbScript));
  _getIt.registerFactory<FlutterSecureStorage>(
    () => FakeFlutterSecureStorage(),
  );
}
