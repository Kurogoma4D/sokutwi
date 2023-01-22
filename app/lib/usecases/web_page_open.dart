import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final privacyPolicyOpener = Provider.autoDispose(
  (ref) => () {
    launchUrlString('https://privacy-policy.krgm4d.dev/sokutwi');
  },
);

final buyMeACoffeeOpener = Provider.autoDispose(
  (ref) => () {
    launchUrlString('https://www.buymeacoffee.com/kurogoma4d');
  },
);
