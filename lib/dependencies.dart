import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'config/assets.dart';
import 'core/sqlite/sqlite_client.dart';
import 'modules/auth/auth_module.dart';
import 'modules/auth/auth_module_impl.dart';
import 'modules/auth/services/local_auth_client.dart';
import 'modules/destinations/destination_module.dart';
import 'modules/destinations/destination_module_impl.dart';
import 'modules/destinations/services/destination_api_client.dart';
import 'modules/destinations/services/destination_metadata_client.dart';

final _getIt = GetIt.I;

Future<void> setupDependencies() async {
  await _registerCoreDependencies();
  await _registerAuthDependencies();
  await _registerDestinationDependencies();

  await _getIt.get<SqliteClient>().open();
  await _getIt<AuthModule>().initialize();
}

Future<void> _registerAuthDependencies() async {
  _getIt.registerSingleton<AuthModule>(
    AuthModuleImpl(
      apiClient: LocalAuthClient(sqliteClient: _getIt<SqliteClient>()),
    ),
  );
}

Future<void> _registerDestinationDependencies() async {
  _getIt.registerSingleton<DestinationModule>(
    DestinationModuleImpl(
      metadataClient: DestinationMetadataClient(
        sqliteClient: _getIt<SqliteClient>(),
      ),
      apiClient: DestinationApiClient(),
      userIdProvider: () => _getIt<AuthModule>().profileNotifier.value?.id,
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
  _getIt.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
}
