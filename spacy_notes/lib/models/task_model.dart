// lib/models/task_model.dart
class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String groupId;
  final String createdBy;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.groupId,
    required this.createdBy,
  });

  factory TaskModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      groupId: data['groupId'] ?? '',
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'groupId': groupId,
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
    };
  }
}
