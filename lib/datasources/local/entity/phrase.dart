import 'package:hive/hive.dart';

part 'phrase.g.dart';

@HiveType(typeId: 0)
class Phrase extends HiveObject {
  @HiveField(0)
  final String text;

  Phrase({required this.text});
}
