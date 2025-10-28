import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/core/sqlite/sqlite_client.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module_impl.dart';
import 'package:hot_tourist_destinations/modules/auth/services/local_auth_client.dart';
import 'package:hot_tourist_destinations/modules/auth/services/token_store.dart';

import 'fakes/fake_flutter_secure_storage.dart';
import 'fakes/sqlite.dart' as sqlite;

final _getIt = GetIt.I;
Future<void> setupDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dbScript = await sqlite.dbScript;

  _getIt.registerFactoryAsync<SqliteClient>(() async {
    final client = sqlite.inMemoryClient(dbScript);
    await client.open();

    return client;
  });
  _getIt.registerFactory<FlutterSecureStorage>(
    () => FakeFlutterSecureStorage(),
  );

  _getIt.registerFactoryAsync<AuthModule>(() async {
    final SqliteClient sqliteClient = await _getIt.getAsync();

    return AuthModuleImpl(
      apiClient: LocalAuthClient(sqliteClient: sqliteClient),
      tokenStore: TokenStore(secureStorage: _getIt()),
    );
  });
}
