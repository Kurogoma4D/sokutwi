import 'package:floor/floor.dart';
import 'package:sokutwi/datasources/local/entity/phrase.dart';

@dao
abstract class PhraseDao {
  @insert
  Future<void> addPhrase(Phrase phrase);

  @Query('SELECT * FROM Phrase WHERE userId = :userId')
  Future<List<Phrase>> findPhraseByUserId(String userId);
}
