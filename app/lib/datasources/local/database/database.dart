import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/local/dao/phrase_dao.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Phrase])
abstract class AppDatabase extends FloorDatabase {
  PhraseDao get phraseDao;
}

final appDatabase = Provider<AppDatabase>((ref) => throw UnimplementedError());
