import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/core/sqlite/sqlite_client.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module_impl.dart';
import 'package:hot_tourist_destinations/modules/auth/services/local_auth_client.dart';
import 'package:hot_tourist_destinations/modules/destinations/destination_module.dart';
import 'package:hot_tourist_destinations/modules/destinations/destination_module_impl.dart';
import 'package:hot_tourist_destinations/modules/destinations/services/destination_api_client.dart';
import 'package:hot_tourist_destinations/modules/destinations/services/destination_metadata_client.dart';

import 'fakes/fake_flutter_secure_storage.dart';
import 'fakes/sqlite.dart' as sqlite;

final _getIt = GetIt.I;

Future<void> setupDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _getIt.reset();

  final dbScript = await sqlite.dbScript;

  _getIt.registerSingleton<SqliteClient>(
    sqlite.inMemoryClient(dbScript),
    dispose: (client) {
      client.close();
    },
  );

  _getIt.registerSingleton<FlutterSecureStorage>(FakeFlutterSecureStorage());

  _getIt.registerSingleton<AuthModule>(
    AuthModuleImpl(apiClient: LocalAuthClient(sqliteClient: _getIt())),
  );

  _getIt.registerSingleton<DestinationModule>(
    DestinationModuleImpl(
      apiClient: DestinationApiClient(),
      metadataClient: DestinationMetadataClient(sqliteClient: _getIt()),
      userIdProvider: () {
        final authModule = _getIt<AuthModule>();
        final profile = authModule.getProfile();
        return profile?.id;
      },
    ),
  );

  await _getIt<SqliteClient>().open();
}
