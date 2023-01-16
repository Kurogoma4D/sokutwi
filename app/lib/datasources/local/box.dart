import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';

final phrasesHiveBox = Hive.openBox<Phrase>('phrases');

final phrasesBox =
    Provider.autoDispose<Box<Phrase>>((ref) => throw UnimplementedError());
