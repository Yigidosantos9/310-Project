import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String content;
  final String createdBy;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> data, String id) {
    return NoteModel(
      id: id,
      content: data['content'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'content': content, 'createdBy': createdBy, 'createdAt': createdAt};
  }
}
