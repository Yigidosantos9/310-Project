import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/models/task_model.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/task_provider.dart';

class TeamNamePage extends StatelessWidget {
  const TeamNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final team = ModalRoute.of(context)!.settings.arguments as TeamModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: team.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DescriptionCard(team: team),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MembersSection(team: team),
            ),
            const SizedBox(height: 24),
            TasksSection(team: team),
            const SizedBox(height: 24),
            _SettingsSection(settings: team.settings),
          ],
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final TeamModel team;
  const _DescriptionCard({required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.mainButtonColor.withOpacity(0.5)),
      ),
      color: const Color.fromARGB(255, 17, 1, 37).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/astronaut.png'),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: team.name,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSecondary,
              fontFamily: "jersey",
            ),
            const SizedBox(height: 8),
            CustomText(
              text: team.description,
              color: AppColors.onPrimary,
              fontSize: 16,
              fontFamily: "jersey",
              textAlign: TextAlign.center,
            ),
            if (!(team.settings['canOnlyMyself'] == true))
              CustomText(
                text: "Team Code: ${team.code}",
                color: AppColors.onPrimary,
                fontSize: 16,
                fontFamily: "jersey",
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class MembersSection extends StatelessWidget {
  final TeamModel team;
  const MembersSection({super.key, required this.team});

  Future<List<String>> _getUsernames(List<String> uids) async {
    return await Future.wait(
      uids.map((uid) async {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        return doc.data()?['username'] ?? 'Unknown';
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getUsernames(team.members),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final usernames = snapshot.data!;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.mainButtonColor.withOpacity(0.5)),
          ),
          color: const Color.fromARGB(255, 17, 1, 37).withOpacity(0.8),
          child: SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: usernames.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder:
                  (context, i) => Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/images/astronaut.png',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: usernames[i],
                        fontSize: 16,
                        color: AppColors.onSecondary,
                        fontFamily: "jersey",
                      ),
                    ],
                  ),
            ),
          ),
        );
      },
    );
  }
}

class TasksSection extends ConsumerStatefulWidget {
  final TeamModel team;
  const TasksSection({super.key, required this.team});

  @override
  ConsumerState<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends ConsumerState<TasksSection> {
  @override
  Widget build(BuildContext context) {
    final taskController = ref.read(taskControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "- Tasks -",
                  color: AppColors.selectedTaskColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                GestureDetector(
                  child: const CustomText(
                    text: "See All",
                    color: AppColors.mainButtonColor,
                    fontSize: 16,
                  ),
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/tasks', arguments: widget.team);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('tasks')
                    .where('groupId', isEqualTo: widget.team.id)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    const CustomText(
                      text: "No tasks yet.",
                      color: AppColors.onPrimary,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed('/tasks', arguments: widget.team);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainButtonColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        text: "Create Task",
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "jersey",
                      ),
                    ),
                  ],
                );
              }

              final docs = snapshot.data!.docs;
              final tasks =
                  docs
                      .take(4)
                      .map(
                        (doc) => TaskModel.fromFirestore(
                          doc.id,
                          doc.data() as Map<String, dynamic>,
                        ),
                      )
                      .toList();

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors.mainButtonColor.withOpacity(0.5),
                  ),
                ),
                color: const Color.fromARGB(255, 17, 1, 37).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children:
                        tasks
                            .map(
                              (task) => Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.grayTextColor.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.mainButtonColor
                                          .withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: task.isCompleted,
                                        onChanged: (_) async {
                                          await taskController.toggleCompleted(
                                            task,
                                          );
                                        },
                                        activeColor: AppColors.mainButtonColor
                                            .withOpacity(0.5),
                                        checkColor: AppColors.background,
                                        side: BorderSide(
                                          color: AppColors.mainButtonColor
                                              .withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomText(
                                          text: task.title,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.onSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatefulWidget {
  final Map<String, bool> settings;
  const _SettingsSection({super.key, required this.settings});

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  late List<bool> switches;

  @override
  void initState() {
    super.initState();
    switches = [
      widget.settings['canBeSeen'] ?? false,
      widget.settings['canBeJoined'] ?? false,
      widget.settings['canChangeIcon'] ?? false,
      widget.settings['canChangeDescName'] ?? false,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "- Settings -",
            color: AppColors.selectedTaskColor,
          ),
          const SizedBox(height: 12),
          ...List.generate(switches.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Let others see this team",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onPrimary,
                  ),
                  Switch(
                    value: switches[index],
                    onChanged: (value) {
                      setState(() => switches[index] = value);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.purple,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
