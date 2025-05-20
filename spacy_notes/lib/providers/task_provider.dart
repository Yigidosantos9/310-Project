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
            snapshot.docs
                .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
                .toList(),
      );
});

final taskControllerProvider = Provider((ref) => TaskController());

class TaskController {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> addTask(String title, String desc, String groupId) async {
    final newTaskRef = await firestore.collection('tasks').add({
      'title': title,
      'description': desc,
      'isCompleted': false,
      'groupId': groupId,
      'createdBy': user!.uid,
      'createdAt': DateTime.now(),
      'completedBy': '',
      'completedAt': null,
    });

    // Toplam görev sayısını arttır
    final userDocRef = firestore.collection('users').doc(user!.uid);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      int totalTasks = (data['totalTasks'] ?? 0) + 1;

      transaction.update(userDocRef, {'totalTasks': totalTasks});
    });
  }

  Future<void> deleteTask(TaskModel task) async {
    final userId = user!.uid;

    await firestore.collection('tasks').doc(task.id).delete();

    final userDocRef = firestore.collection('users').doc(userId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      int completed = (data['tasksCompleted'] ?? 0);
      int total = (data['totalTasks'] ?? 0);

      if (task.isCompleted) {
        completed = completed > 0 ? completed - 1 : 0;
      }

      total = total > 0 ? total - 1 : 0;

      transaction.update(userDocRef, {
        'tasksCompleted': completed,
        'totalTasks': total,
      });
    });
  }

  Future<void> toggleCompleted(TaskModel task) async {
    final currentUserId = user!.uid;
    final newValue = !task.isCompleted;
    final taskRef = firestore.collection('tasks').doc(task.id);
    final previousCompletedBy = task.completedBy;

    // 1- Görevin isCompleted durumunu tersine çevir
    await taskRef.update({
      'isCompleted': newValue,
      'completedBy': newValue ? currentUserId : '',
      'completedAt': newValue ? DateTime.now() : null,
    });

    // 2- Firestore transaction ile user'lara puan güncelle
    await firestore.runTransaction((transaction) async {
      // Eğer görev daha önce bir kullanıcı tarafından tamamlanmışsa ve o kullanıcı farklıysa
      final previousCompletedBy = task.completedBy ?? '';
      if (previousCompletedBy.isNotEmpty &&
          previousCompletedBy != currentUserId) {
        final previousUserRef = firestore
            .collection('users')
            .doc(previousCompletedBy);
        final previousUserSnap = await transaction.get(previousUserRef);
        if (previousUserSnap.exists) {
          final prevData = previousUserSnap.data()!;
          final prevCompleted = (prevData['tasksCompleted'] ?? 0) as int;
          transaction.update(previousUserRef, {
            'tasksCompleted': prevCompleted > 0 ? prevCompleted - 1 : 0,
          });
        }
      }

      // Şu anki kullanıcıya göre güncelleme
      final currentUserRef = firestore.collection('users').doc(currentUserId);
      final currentUserSnap = await transaction.get(currentUserRef);
      if (currentUserSnap.exists) {
        final currData = currentUserSnap.data()!;
        int currCompleted = (currData['tasksCompleted'] ?? 0) as int;

        currCompleted =
            newValue
                ? currCompleted + 1
                : (currCompleted > 0 ? currCompleted - 1 : 0);

        transaction.update(currentUserRef, {'tasksCompleted': currCompleted});
      }
    });
  }
}
