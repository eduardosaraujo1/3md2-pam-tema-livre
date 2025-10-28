import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'config/assets.dart';
import 'core/sqlite/sqlite_client.dart';
import 'modules/auth/services/token_store.dart';

final _getIt = GetIt.I;

Future<void> initialize() async {
  await _registerCoreDependencies();
  await _registerAuthDependencies();
}

Future<void> _registerAuthDependencies() async {
  _getIt.registerSingleton<TokenStore>(
    TokenStore(secureStorage: _getIt<FlutterSecureStorage>()),
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
  );
  _getIt.registerSingleton(FlutterSecureStorage());
}
