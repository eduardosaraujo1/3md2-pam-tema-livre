import 'package:projeto_livre_pam/core/sqlite/sqlite_client.dart';

SqliteClient inMemoryClient(String dbScript) {
  return SqliteClient(
    databaseFileName: ':memory:',
    onCreate: (database, version) {
      return database.execute(dbScript);
    },
  );
}
