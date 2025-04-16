import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class Task {
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      isCompleted: true,
    ),
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      isCompleted: true,
    ),
    Task(
      title: 'Complete CS300 homework',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'GROUP TASKS'),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: tasks[index],
            onToggleCompleted: () {
              setState(() {
                tasks[index].isCompleted = !tasks[index].isCompleted;
              });
            },
            onDelete: () {
              setState(() {
                tasks.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          backgroundColor: AppColors.mainButtonColor,
          shape: const CircleBorder(),
          onPressed: () {
            setState(() {
              tasks.add(Task(title: '', description: ''));
            });
          },
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
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
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.selectedTaskColor : Colors.white,
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
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  size: 50,
                  color: AppColors.mainButtonColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      onChanged: (val) => task.title = val,
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontFamily: 'Jersey',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter task title',
                      ),
                    ),
                    TextField(
                      controller: descController,
                      onChanged: (val) => task.description = val,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Jersey',
                        color: AppColors.darkSubTextColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter task description',
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
