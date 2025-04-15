import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Başlangıçta 6 görev var
  List<bool> taskStatus = [false, false, false, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'GROUP TASKS'),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
        itemCount: taskStatus.length,
        itemBuilder: (context, index) {
          return TaskCard(
            isCompleted: taskStatus[index],
            onTapIcon: () {
              setState(() {
                taskStatus[index] = !taskStatus[index];
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
              // taskStatus.insert(0, false); // if you want to add the new task to the beginning
              taskStatus.add(false); // adding the new task to the end
            });
          },
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTapIcon;

  const TaskCard({
    super.key,
    required this.isCompleted,
    required this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.selectedTaskColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapIcon,
            child: Icon(
              isCompleted
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
              children: const [
                CustomText(
                  text: 'Complete CS300 homework',
                  fontSize: 23,
                  color: Colors.black,
                ),
                SizedBox(height: 4),
                CustomText(
                  text:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the',
                  fontSize: 20,
                  color: AppColors.darkSubTextColor,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
