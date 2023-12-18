import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime creationDate;
  @HiveField(3)
  DateTime lastModifiedDate;
  NoteModel(
      {required this.title,
      required this.description,
      required this.creationDate,
      required this.lastModifiedDate});
}
