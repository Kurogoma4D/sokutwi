import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/app.dart';
import 'package:sokutwi/datasources/local/database/database.dart';
import 'package:sokutwi/mock_overrides.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  final rootContainer = ProviderContainer(
    overrides: [
      appDatabase.overrideWithValue(database),
      if (const bool.fromEnvironment('mock')) ...mockOverrides,
    ],
  );

  await rootContainer.read(tryObtainAuthToken)();

  runApp(ProviderScope(
    parent: rootContainer,
    child: const App(),
  ));
}
