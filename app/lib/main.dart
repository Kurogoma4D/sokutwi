import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/app.dart';
import 'package:sokutwi/datasources/local/database/database.dart';
import 'package:sokutwi/mock_overrides.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';

final _rootContainer = ProviderContainer();

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  final controller = _rootContainer.read(authTokenStore.notifier);
  final cachedToken = await _rootContainer.read(obtainCachedAuthToken.future);
  if (cachedToken.isValid) {
    controller.state = AsyncData(cachedToken);
  }

  if (cachedToken.expireAt < DateTime.now().millisecondsSinceEpoch) {
    _rootContainer.read(refreshAuthToken)(cachedToken.refreshToken);
  }

  runApp(ProviderScope(
    overrides: [
      if (const bool.fromEnvironment('mock')) ...mockOverrides,
      appDatabase.overrideWithValue(database),
    ],
    parent: _rootContainer,
    child: const App(),
  ));
}
