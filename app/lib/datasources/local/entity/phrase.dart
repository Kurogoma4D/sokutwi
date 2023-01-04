import 'package:floor/floor.dart';

@entity
class Phrase {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String userId;
  final String text;

  Phrase({this.id = 0, required this.userId, required this.text});
}
