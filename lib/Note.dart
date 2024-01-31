import 'package:hive/hive.dart';

@HiveType(typeId: 0)
part "Note.g.dart";

class Note {
  @HiveField(0)
  String noteText = "";
  @HiveField(1)
  String noteDate = "";
  @HiveField(2)
  String noteColor = "";
}
