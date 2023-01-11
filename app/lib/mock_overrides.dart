import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/local/database/database.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sokutwi/usecases/fixed_phrases.dart';
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

Future<void> initiateDatabase(AppDatabase database) async {
  final random = Random();
  final phrases = List.generate(
    20,
    (i) => PhraseData(id: i, text: '#${random.nextInt(12000) * i}'),
  );
  await database.database.delete('Phrase');
  for (final phrase in phrases) {
    await database.phraseDao.addPhrase(Phrase(text: phrase.text));
  }
}
