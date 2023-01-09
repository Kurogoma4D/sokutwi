// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PhraseDao? _phraseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Phrase` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PhraseDao get phraseDao {
    return _phraseDaoInstance ??= _$PhraseDao(database, changeListener);
  }
}

class _$PhraseDao extends PhraseDao {
  _$PhraseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _phraseInsertionAdapter = InsertionAdapter(
            database,
            'Phrase',
            (Phrase item) =>
                <String, Object?>{'id': item.id, 'text': item.text},
            changeListener),
        _phraseDeletionAdapter = DeletionAdapter(
            database,
            'Phrase',
            ['id'],
            (Phrase item) =>
                <String, Object?>{'id': item.id, 'text': item.text},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Phrase> _phraseInsertionAdapter;

  final DeletionAdapter<Phrase> _phraseDeletionAdapter;

  @override
  Stream<List<Phrase>> obtainAllPhrases() {
    return _queryAdapter.queryListStream('SELECT * FROM Phrase',
        mapper: (Map<String, Object?> row) =>
            Phrase(id: row['id'] as int?, text: row['text'] as String),
        queryableName: 'Phrase',
        isView: false);
  }

  @override
  Future<void> addPhrase(Phrase phrase) async {
    await _phraseInsertionAdapter.insert(phrase, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePhrase(Phrase phrase) async {
    await _phraseDeletionAdapter.delete(phrase);
  }

  @override
  Future<void> addPhrases(Iterable<Phrase> phrases) async {
    if (database is sqflite.Transaction) {
      await super.addPhrases(phrases);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.phraseDao.addPhrases(phrases);
      });
    }
  }
}
