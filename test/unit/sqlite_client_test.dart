import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_livre_pam/core/sqlite/sqlite_client.dart';

void main() {
  /** Requirements:
   * It stores value persistently and retrieves.
   */
  late SqliteClient sqliteClient;
  setUp(() {
    sqliteClient = SqliteClient(
      databaseFileName: ':memory:',
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE test_table (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT)',
        );
      },
    );
  });

  test("it stored value persistently and retrieves", () async {
    await sqliteClient.connect();
    await sqliteClient.database.insert('test_table', {'value': 'test_user'});

    final List<Map<String, dynamic>> result = await sqliteClient.database.query(
      'test_table',
    );

    expect(result.first['value'], equals('test_user'));
    expect(result.first['id'], isNotNull);
  });
}
