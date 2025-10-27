// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environment {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await dotenv.load(fileName: ".env", isOptional: true);
      _initialized = true;
    }
  }

  static void _assertInitialized() {
    if (!_initialized) {
      throw Exception(
        "Environment not initialized. Call Environment.initialize() before accessing variables.",
      );
    }
  }

  static String get APP_ENVIRONMENT {
    _assertInitialized();
    return dotenv.env['APP_ENVIRONMENT'] ?? '';
  }
}
