import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/twitter_client.dart';

enum TweetResult { done, clientNotReady, rateLimitExceeded }

extension TweetResultPatternMatch on TweetResult {
  T when<T>({
    required T Function() done,
    required T Function() clientNotReady,
    required T Function() rateLimitExceeded,
  }) {
    switch (this) {
      case TweetResult.done:
        return done();
      case TweetResult.clientNotReady:
        return clientNotReady();
      case TweetResult.rateLimitExceeded:
        return rateLimitExceeded();
    }
  }
}

final postTweet = Provider.autoDispose((ref) {
  final client = ref.watch(twitterClient);

  return (String text) async {
    if (client == null) {
      return TweetResult.clientNotReady;
    }

    final response = await client.tweets.createTweet(text: text);
    if (response.rateLimit.isExceeded) {
      return TweetResult.rateLimitExceeded;
    }

    return TweetResult.done;
  };
});
