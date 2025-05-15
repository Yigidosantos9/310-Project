import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String groupId;
  final String createdBy;
  final DateTime? createdAt;
  final String? completedBy;
  final DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.groupId,
    required this.createdBy,
    this.createdAt,
    this.completedBy,
    this.completedAt,
  });

  factory TaskModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      groupId: data['groupId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      completedBy: data['completedBy'],
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'groupId': groupId,
      'createdBy': createdBy,
      'createdAt': createdAt ?? DateTime.now(),
      if (completedBy != null) 'completedBy': completedBy,
      if (completedAt != null) 'completedAt': completedAt,
    };
  }
}