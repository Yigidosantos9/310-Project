import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/models/task_model.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/task_provider.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final team = ModalRoute.of(context)?.settings.arguments as TeamModel?;
    
    if (team == null) {
      return const Scaffold(
        body: Center(child: Text("Team info cannot found.")),
      );
    }

    final taskListAsync = ref.watch(taskListProvider(team.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: team.name, subTitle: "TASKS"),
      body: taskListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (tasks) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskCard(
              task: task,
              onToggleCompleted: () => ref.read(taskControllerProvider).toggleCompleted(task),
              onDelete: () => ref.read(taskControllerProvider).deleteTask(task),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainButtonColor,
        shape: const CircleBorder(),
        onPressed: () => _showAddTaskDialog(context, ref, team.id),
        child: const Icon(Icons.add, size: 36, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref, String groupId) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        title: const CustomText(
          text: 'New Task',
          fontSize: 24,
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainButtonColor),
            onPressed: () {
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              if (title.isNotEmpty) {
                ref.read(taskControllerProvider).addTask(title, desc, groupId);
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