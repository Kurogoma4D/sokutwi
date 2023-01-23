import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:sokutwi/datasources/local/box.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sokutwi/usecases/tweet_text.dart';

part 'fixed_phrases.freezed.dart';

@freezed
class PhraseData with _$PhraseData {
  const factory PhraseData({
    Object? id,
    required String text,
  }) = _PhraseData;
}

final _temporaryPath = FutureProvider(
  (ref) async => await getTemporaryDirectory(),
);

final obtainSavedPhrases = StreamProvider.autoDispose(
  (ref) async* {
    final box = ref.watch(phrasesBox);
    if (ref.state.isLoading) {
      yield box.values.map((e) => PhraseData(id: e.key, text: e.text));
    }

    final stream = box.watch();

    await for (final _ in stream) {
      yield box.values.map((e) => PhraseData(id: e.key, text: e.text));
    }
  },
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

      final box = ref.read(phrasesBox);
      await box.add(Phrase(text: text));
    };
  },
);

final _saveMultiplePhrases = Provider.autoDispose(
  (ref) => (Iterable<String> texts) async {
    final box = ref.read(phrasesBox);
    final phrases = texts.map((e) => Phrase(text: e));

    final appendablePhrase = <Phrase>[];
    for (final phrase in phrases) {
      final canSave = (await ref.read(_canSavePhrase.future))(phrase.text);
      if (canSave) appendablePhrase.add(phrase);
    }

    await box.addAll(appendablePhrase);
  },
);

final applyPhrase = Provider.autoDispose(
  (ref) => (PhraseData data) {
    ref.read(updateTweetText)(data.text);
  },
);

final obtainRandomPhrase = Provider.autoDispose(
  (ref) => (Iterable<PhraseData> phrases) {
    if (phrases.isEmpty) return const PhraseData(id: 0, text: '');

    final randomized = [...phrases]..shuffle();
    return randomized.first;
  },
);

final deletePhrase = Provider.autoDispose(
  (ref) => (PhraseData data) async {
    final box = ref.read(phrasesBox);

    await box.delete(data.id);
  },
);

final importPhrases = Provider.autoDispose(
  (ref) => () async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    final file = () {
      if (kIsWeb) {
        final bytes = result?.files.first;
        if (bytes == null) return null;
        return XFile.fromData(bytes.bytes ?? Uint8List(0));
      } else {
        final path = result?.paths.first;
        if (path == null) return null;
        return XFile(path);
      }
    }();
    if (file == null) return;

    final csv = await file.readAsString();
    final phraseStrings = const CsvToListConverter().convert(csv);

    if (phraseStrings.isEmpty) return;

    final phrases = phraseStrings.first.map((e) => e as String);
    await ref.read(_saveMultiplePhrases)(phrases);
  },
);

final exportPhrases = Provider.autoDispose(
  (ref) => () async {
    final phrases =
        ref.read(obtainSavedPhrases).asData?.value ?? const Iterable.empty();
    if (phrases.isEmpty) return;

    final exportData = [phrases.map((e) => e.text).toList()];
    final csv = const ListToCsvConverter().convert(exportData);

    final directory = await ref.read(_temporaryPath.future);
    final nowDate = DateTime.now().toIso8601String();
    final file = File('${directory.path}/export_twi_$nowDate.csv');
    final resultFile = await file.writeAsString(csv);
    final shareFile = XFile(resultFile.path);

    try {
      Share.shareXFiles([shareFile]);
    } catch (e) {
      debugPrint(e.toString());
    }
  },
);
