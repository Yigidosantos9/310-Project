// lib/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

final taskListProvider = StreamProvider.family<List<TaskModel>, String>((
  ref,
  groupId,
) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || groupId.isEmpty) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('tasks')
      .where('groupId', isEqualTo: groupId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) {
              return TaskModel.fromFirestore(doc.id, doc.data());
            }).toList(),
      );
});

final taskControllerProvider = Provider((ref) => TaskController());

class TaskController {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> addTask(String title, String desc, String groupId) async {
    await firestore.collection('tasks').add({
      'title': title,
      'description': desc,
      'isCompleted': false,
      'groupId': groupId,
      'createdBy': user!.uid,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> deleteTask(String id) async {
    await firestore.collection('tasks').doc(id).delete();
  }

  Future<void> toggleCompleted(TaskModel task) async {
    await firestore.collection('tasks').doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }
}
