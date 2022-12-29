import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextEx on BuildContext {
  AppLocalizations get string => AppLocalizations.of(this)!;
}
