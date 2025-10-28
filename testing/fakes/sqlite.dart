import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hot_tourist_destinations/config/assets.dart';
import 'package:hot_tourist_destinations/core/sqlite/sqlite_client.dart';

SqliteClient inMemoryClient(String dbScript) {
  return SqliteClient(
    databaseFileName: ':memory:',
    onCreate: (database, version) {
      return database.execute(dbScript);
    },
  );
}

Future<String> get dbScript async =>
    await rootBundle.loadString(Assets.createDbScript);
