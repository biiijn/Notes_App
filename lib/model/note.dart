import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  int? id;
  String title;
  String content;
  DateTime updatedAt;
  bool isSynced;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.isSynced = false,
  });

  // 👉 Local DB (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  // 👉 Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }


  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }
}
