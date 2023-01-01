import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/post_tweet.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';

final mockOverrides = [
  postTweet.overrideWithValue(() async {
    await Future.delayed(const Duration(seconds: 1));
    return const TweetResult.success();
  }),
  authTokenStore.overrideWith(
    (ref) => const AsyncData(TwitterToken(token: 'foo')),
  ),
];
