import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'config/environment.dart';
import 'dependencies.dart' as dependencies;
import 'theme.dart' as theme;

void main() async {
  try {
    Logger.root.level = Level.ALL;

    await Environment.initialize();

    await dependencies.initialize();

    runApp(const MainApp());
  } catch (e, s) {
    runApp(ErrorApp(e, s));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.light,
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp(this.error, this.stacktrace, {super.key});

  final Object error;

  final StackTrace stacktrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 217, 214),
          ),
          child: Column(
            children: [
              Text(
                'An error occurred during initialization:\n\n$error',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                stacktrace.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
