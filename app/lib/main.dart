import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/app.dart';
import 'package:sokutwi/datasources/local/database/database.dart';
import 'package:sokutwi/mock_overrides.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(ProviderScope(
    overrides: [
      if (const bool.fromEnvironment('mock')) ...mockOverrides,
      appDatabase.overrideWithValue(database),
    ],
    child: const App(),
  ));
}
