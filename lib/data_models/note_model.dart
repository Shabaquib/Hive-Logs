import 'package:hive_flutter/hive_flutter.dart';

part 'note_model.g.dart';

/*
Every Note requires some data!
Note Title
Note Content
LastSaveTime
ifInRecycleBin
maxLines
backgroundColor
*/

@HiveType(typeId: 1)
class Note {
  Note(
      {required this.noteTopic,
      required this.noteContent,
      required this.lastSaved,
      required this.isInTrash,
      required this.colorMap});

  @HiveField(0)
  String noteTopic;

  @HiveField(1)
  String noteContent;

  @HiveField(2)
  String lastSaved;

  @HiveField(3)
  bool isInTrash;

  @HiveField(4)
  List<int> colorMap;
}
