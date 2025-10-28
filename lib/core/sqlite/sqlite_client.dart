import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Cross-platform SQLite database wrapper using sqflite_common_ffi
///
/// Supports iOS, Android, Windows, Linux, and MacOS.
/// Each instance manages a separate database file.
/// Must be initialized before use by calling [open].
class SqliteClient {
  SqliteClient({
    required this.databaseFileName,
    required this.onCreate,
    this.version = 1,
  });

  /// The name of the database file
  ///
  /// Use ':memory:' for in-memory database
  final String databaseFileName;

  /// Callback to create the database schema on first initialization
  final Future<void> Function(Database db, int version) onCreate;

  /// Database schema version
  final int version;

  Database? _database;
  static DatabaseFactory? _databaseFactory;

  /// Get the database instance
  ///
  /// Throws [StateError] if not initialized. Call [open] first.
  Database get database {
    if (_database == null) {
      throw StateError(
        'Database not initialized. Call open() before using the database.',
      );
    }
    return _database!;
  }

  /// Get the appropriate database factory for the platform
  static DatabaseFactory get databaseFactory {
    if (_databaseFactory != null) {
      return _databaseFactory!;
    }

    // Initialize FFI for Windows/Linux
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      _databaseFactory = databaseFactoryFfi;
    } else {
      // On iOS/Android/MacOS, use the default factory
      // This will use the system SQLite (or sqlite3_flutter_libs if added)
      _databaseFactory = databaseFactoryFfi;
    }

    return _databaseFactory!;
  }

  /// Initialize the database
  ///
  /// Creates the database file if it doesn't exist and runs [onCreate] callback.
  /// Subsequent calls will reuse the existing database.
  Future<void> open() async {
    if (_database != null) {
      return; // Already initialized
    }

    // Handle in-memory database
    late String path;
    if (databaseFileName == ':memory:') {
      path = inMemoryDatabasePath;
    } else {
      // Get the application documents directory for persistent storage
      final databasesPath = await getApplicationDocumentsDirectory();
      path = p.join(databasesPath.path, databaseFileName);
    }

    // Open or create the database
    _database = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: version, onCreate: onCreate),
    );
  }

  /// Close the database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
