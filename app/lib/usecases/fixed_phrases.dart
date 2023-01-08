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
  dependencies: [appDatabase],
);

final _canSavePhrase = FutureProvider.autoDispose((ref) async {
  final savedPhrases = await ref.watch(obtainSavedPhrases.future);
  return (String text) => !savedPhrases.map((e) => e.text).contains(text);
});

final savePhrase = Provider.autoDispose(
  (ref) {
    final text = ref.watch(inputTweetText);
    return () async {
      if (text.isEmpty) return;
      final canSave = (await ref.read(_canSavePhrase.future))(text);
      if (!canSave) return;

      final database = ref.watch(appDatabase);
      await database.phraseDao.addPhrase(Phrase(text: text));
    };
  },
);

final applyPhrase = Provider.autoDispose(
  (ref) => (PhraseData data) {
    ref.read(updateTweetText)(data.text);
  },
);

final applySomePhrase = Provider.autoDispose(
  (ref) => (Iterable<PhraseData> phrases) {
    if (phrases.isEmpty) return;

    final randomized = [...phrases]..shuffle();
    ref.read(updateTweetText)(randomized.first.text);
  },
);

final deletePhrase = Provider.autoDispose(
  (ref) => (PhraseData data) async {
    final database = ref.read(appDatabase);
    await database.phraseDao.deletePhrase(Phrase(id: data.id, text: data.text));
  },
);
