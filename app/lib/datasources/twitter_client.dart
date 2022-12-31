import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

final twitterClient = Provider((ref) {
  final tokens = ref.watch(authTokenStore).asData;

  if (tokens == null) {
    return null;
  }

  return v2.TwitterApi(bearerToken: tokens.value.token);
});
