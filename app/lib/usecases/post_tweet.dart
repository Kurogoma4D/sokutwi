import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:sokutwi/usecases/tutorial_controls.dart';
import 'package:sokutwi/usecases/tweet_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  }) = TweetFail;
}

final postTweet = Provider.autoDispose((ref) {
  final text = ref.watch(inputTweetText);

  return () async {
    await ref.read(markDontShowTutorial)();
    const base = 'https://twitter.com/intent/tweet';
    final url = '$base?text=$text';
    final encoded = Uri.encodeFull(url);
    if (await canLaunchUrlString(encoded)) {
      await launchUrlString(encoded);
      return const TweetResult.success();
    }

    return const TweetResult.fail(kind: TweetFailKind.other);
  };
});
