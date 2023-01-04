import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/local/database/database.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sokutwi/usecases/tweet_text.dart';

part 'fixed_phrases.freezed.dart';

@freezed
class PhraseData with _$PhraseData {
  const factory PhraseData({
    required int id,
    required String text,
  }) = _PhraseData;
}

final obtainSavedPhrases = StreamProvider.autoDispose(
  (ref) {
    final database = ref.watch(appDatabase);
    return database.phraseDao.obtainAllPhrases().map((phrases) =>
        phrases.map((e) => PhraseData(id: e.id ?? 0, text: e.text)));
  },
);

final savePhrase = Provider.autoDispose(
  (ref) {
    final text = ref.watch(inputTweetText);
    return () async {
      if (text.isEmpty) return;

      final database = ref.watch(appDatabase);
      await database.phraseDao.addPhrase(Phrase(text: text));
    };
  },
);
