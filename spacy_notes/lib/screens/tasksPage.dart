import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/models/task_model.dart';
import 'package:spacy_notes/providers/task_provider.dart';
import 'package:spacy_notes/providers/group_provider.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final groupId = ref.watch(currentGroupIdProvider);
    final taskListAsync = ref.watch(taskListProvider(groupId ?? ""));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'GROUP', subTitle: 'TASKS'),
      body: taskListAsync.when(
        data:
            (tasks) => ListView.builder(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onToggleCompleted:
                      () => ref
                          .read(taskControllerProvider)
                          .toggleCompleted(task),
                  onDelete:
                      () =>
                          ref.read(taskControllerProvider).deleteTask(task.id),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainButtonColor,
        shape: const CircleBorder(),
        onPressed: () => _showAddTaskDialog(context, groupId!),
        child: const Icon(Icons.add, size: 36, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, String groupId) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            title: const CustomText(
              text: 'New Task',
              fontSize: 24,
              //fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Jersey',
                    color: AppColors.mainTextColor,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    hintStyle: TextStyle(
                      color: AppColors.darkSubTextColor,
                      fontFamily: 'Jersey',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Jersey',
                    color: AppColors.darkSubTextColor,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Task description',
                    hintStyle: TextStyle(
                      color: AppColors.darkSubTextColor,
                      fontFamily: 'Jersey',
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainButtonColor,
                ),
                onPressed: () {
                  final title = titleController.text.trim();
                  final desc = descController.text.trim();
                  if (title.isNotEmpty) {
                    ref
                        .read(taskControllerProvider)
                        .addTask(title, desc, groupId);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDone ? AppColors.selectedTaskColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onToggleCompleted,
                child: Icon(
                  isDone
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  size: 40,
                  color: AppColors.mainButtonColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: task.title,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: CustomText(
                          text: task.description,
                          fontSize: 16,
                          color: AppColors.darkSubTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.delete,
                size: 24,
                color: AppColors.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
