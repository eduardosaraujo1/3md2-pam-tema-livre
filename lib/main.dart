import 'package:flutter/material.dart';

import 'config/environment.dart';
import 'dependencies.dart';
import 'routing/router.dart';
import 'theme.dart' as themes;

void main() async {
  await Environment.initialize();

  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hot Tourist Destinations',
      theme: themes.light,
      darkTheme: themes.dark,
      themeMode: ThemeMode.light,
      routerConfig: context.router,
    );
  }
}
