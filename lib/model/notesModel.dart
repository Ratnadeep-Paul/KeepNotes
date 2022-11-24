import 'dart:ui';

class NoteImpNames {
  static final String id = "id";
  static final String title = "title";
  static final String content = "content";
  static final String pin = "pin";
  static final String createdTime = "createdTime";
  static final String background = "background";
  static final String TableName = "notes_table";

  static final List<String> values = [
    id,
    title,
    content,
    pin,
    createdTime,
    background
  ];
}

class Note {
  final int? id;
  final String title;
  final String content;
  final bool pin;
  final DateTime createdTime;
  final int background;

  const Note(
      {this.id,
      required this.title,
      required this.content,
      required this.pin,
      required this.createdTime,
      required this.background});

  Note copy(
      {int? id,
      String? title,
      String? content,
      bool? pin,
      DateTime? createdTime,
      int? background}) {
    return Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        pin: pin ?? this.pin,
        createdTime: createdTime ?? this.createdTime,
        background: background ?? this.background);
  }

  static Note fromJson(Map<String, Object?> json) {
    return Note(
        id: json[NoteImpNames.id] as int,
        title: json[NoteImpNames.title] as String,
        content: json[NoteImpNames.content] as String,
        pin: json[NoteImpNames.pin] == 1,
        createdTime: DateTime.parse(json[NoteImpNames.createdTime] as String),
        background: int.parse(json[NoteImpNames.background].toString()) as int);
  }

  Map<String, Object?> toJson() {
    return {
      NoteImpNames.id: id,
      NoteImpNames.title: title,
      NoteImpNames.content: content,
      NoteImpNames.pin: pin ? 1 : 0,
      NoteImpNames.createdTime: createdTime.toIso8601String(),
      NoteImpNames.background: background.toString()
    };
  }

}
