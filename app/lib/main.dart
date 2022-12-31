import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/app.dart';
import 'package:sokutwi/mock_overrides.dart';

void main() {
  runApp(ProviderScope(
    overrides: [
      if (const bool.fromEnvironment('mock')) ...mockOverrides,
    ],
    child: const App(),
  ));
}
