import 'package:floor/floor.dart';

@entity
class Phrase {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String text;

  Phrase({this.id, required this.text});
}
