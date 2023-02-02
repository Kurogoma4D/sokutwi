import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final privacyPolicyOpener = Provider.autoDispose(
  (ref) => () {
    launchUrlString(
      'https://privacy-policy.krgm4d.dev/sokutwi',
      mode: LaunchMode.externalApplication,
    );
  },
);

final sponsorOpener = Provider.autoDispose(
  (ref) => () {
    launchUrlString(
      'https://github.com/sponsors/Kurogoma4D',
      mode: LaunchMode.externalApplication,
    );
  },
);
