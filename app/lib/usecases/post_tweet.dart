import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/twitter_client.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:sokutwi/usecases/tweet_text.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

part 'post_tweet.freezed.dart';

enum TweetFailKind { clientNotReady, rateLimitExceeded, other }

extension TweetFailKindPatternMatch on TweetFailKind {
  T when<T>({
    required T Function() clientNotReady,
    required T Function() rateLimitExceeded,
    required T Function() other,
  }) {
    switch (this) {
      case TweetFailKind.clientNotReady:
        return clientNotReady();
      case TweetFailKind.rateLimitExceeded:
        return rateLimitExceeded();
      case TweetFailKind.other:
        return other();
    }
  }
}

@freezed
class TweetResult<R> with _$TweetResult<R> {
  const factory TweetResult.success() = TweetSuccess<R>;
  const factory TweetResult.fail({
    required TweetFailKind kind,
    TwitterException? error,
  }) = TweetFail;
}

final postTweet = Provider.autoDispose((ref) {
  final client = ref.watch(twitterClient);
  final text = ref.watch(inputTweetText);

  return () async {
    if (client == null) {
      return const TweetResult.fail(kind: TweetFailKind.clientNotReady);
    }

    try {
      final response = await client.tweets.createTweet(text: text);
      if (response.rateLimit.isExceeded) {
        return const TweetResult.fail(kind: TweetFailKind.rateLimitExceeded);
      }
    } catch (e) {
      if (e is TwitterException) {
        return TweetResult.fail(kind: TweetFailKind.other, error: e);
      }
      return const TweetResult.fail(kind: TweetFailKind.other);
    }
    return const TweetResult.success();
  };
});
