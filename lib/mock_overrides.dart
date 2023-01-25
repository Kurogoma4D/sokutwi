import 'dart:math';

import 'package:hive/hive.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sokutwi/usecases/post_tweet.dart';

final mockOverrides = [
  postTweet.overrideWithValue(() async {
    await Future.delayed(const Duration(seconds: 1));
    return const TweetResult.success();
  }),
];

Future<void> initiateDatabase(Box<Phrase> box) async {
  final random = Random();
  final phrases = List.generate(
    20,
    (i) => Phrase(text: '#${random.nextInt(12000) * i}'),
  );
  await box.clear();
  await box.addAll(phrases);
}
