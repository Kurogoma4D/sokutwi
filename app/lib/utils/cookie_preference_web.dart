// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void showCookiePreference() {
  js.context.callMethod('displayPreferenceModal');
}
