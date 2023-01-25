import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sokutwi/app.dart';
import 'package:sokutwi/constants/constants.dart';
import 'package:sokutwi/datasources/local/box.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sokutwi/datasources/shared_preference.dart';
import 'package:sokutwi/mock_overrides.dart';
import 'package:sokutwi/utils/admob.dart'
    if (dart.library.io) 'package:sokutwi/utils/admob_io.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  if (showAd && !kIsWeb) {
    initializeAdmob();
  }
  await Hive.initFlutter();
  Hive.registerAdapter(PhraseAdapter());
  final preferences = await SharedPreferences.getInstance();

  const isMock = bool.fromEnvironment('mock');

  final box = await phrasesHiveBox;

  if (isMock) await initiateDatabase(box);

  final rootContainer = ProviderContainer(
    overrides: [
      phrasesBox.overrideWithValue(box),
      sharedPreferences.overrideWithValue(preferences),
      if (isMock) ...mockOverrides,
    ],
  );

  runApp(ProviderScope(
    parent: rootContainer,
    child: const App(),
  ));
}
