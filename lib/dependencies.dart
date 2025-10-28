import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'config/assets.dart';
import 'core/sqlite/sqlite_client.dart';
import 'modules/auth/auth_module.dart';
import 'modules/auth/auth_module_impl.dart';
import 'modules/auth/services/local_auth_client.dart';
import 'modules/auth/services/token_store.dart';

final _getIt = GetIt.I;

Future<void> setupDependencies() async {
  await _registerCoreDependencies();
  await _registerAuthDependencies();

  await _getIt<AuthModule>().initialize();

  await _getIt.get<SqliteClient>().open();
}

Future<void> _registerAuthDependencies() async {
  _getIt.registerSingleton<TokenStore>(
    TokenStore(secureStorage: _getIt<FlutterSecureStorage>()),
  );
  _getIt.registerSingleton<LocalAuthClient>(
    LocalAuthClient(sqliteClient: _getIt<SqliteClient>()),
  );

  _getIt.registerSingleton<AuthModule>(
    AuthModuleImpl(
      apiClient: _getIt<LocalAuthClient>(),
      tokenStore: _getIt<TokenStore>(),
    ),
  );
}

Future<void> _registerCoreDependencies() async {
  _getIt.registerSingleton<SqliteClient>(
    SqliteClient(
      databaseFileName: 'app_database.db',
      onCreate: (db, version) async {
        final script = await rootBundle.loadString(Assets.createDbScript);

        await db.execute(script);
      },
    ),
    dispose: (client) async {
      await client.close();
    },
  );
  _getIt.registerSingleton(FlutterSecureStorage());
}
