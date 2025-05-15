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
      appBar: CustomAppBar(title: team.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _DescriptionCard(team: team),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: MembersSection(team: team),
            ),
            _TasksSection(team: team,),
            const SizedBox(height: 16),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.selectedTaskColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              text: "- Description -",
              color: AppColors.mainButtonColor,
            ),
          ),
          const SizedBox(height: 8),
          CustomText(text: team.description),
        ],
      ),
    );
  }
}

class MembersSection extends StatefulWidget {
  final TeamModel team;
  const MembersSection({super.key, required this.team});

  @override
  State<MembersSection> createState() => _MembersSectionState();
}

class _MembersSectionState extends State<MembersSection> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<List<String>> get chunked {
    final members = widget.team.members;
    List<List<String>> pages = [];
    for (int i = 0; i < members.length; i += 4) {
      pages.add(members.sublist(i, (i + 4).clamp(0, members.length)));
    }
    return pages;
  }

  Future<List<String>> _getUsernames(List<String> uids) async {
    return await Future.wait(uids.map((uid) async {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data()?['username'] ?? 'Unknown';
    }));
  }

  @override
  Widget build(BuildContext context) {
    final pages = chunked;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.selectedTaskColor,
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            height: 450,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const CustomText(
                  text: "- Members -",
                  color: AppColors.mainButtonColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: pages.length,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemBuilder: (context, pageIndex) {
                        final uids = pages[pageIndex];

                        return FutureBuilder<List<String>>(
                          future: _getUsernames(uids),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final usernames = snapshot.data!;
                            return GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(4, (i) {
                                if (i >= usernames.length) return const SizedBox();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/astronaut.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppColors.unselectedTaskColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: usernames[i],
                                      fontSize: 18,
                                      color: AppColors.mainButtonColor,
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.purple : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TasksSection extends ConsumerStatefulWidget {
  final TeamModel team;
  const _TasksSection({super.key, required this.team});

  @override
  ConsumerState<_TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends ConsumerState<_TasksSection> {
  @override
  Widget build(BuildContext context) {
    final taskController = ref.read(taskControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "- Tasks -", color: AppColors.selectedTaskColor),
              GestureDetector(
                child: CustomText(text: "All", color: AppColors.selectedTaskColor),
                onTap: () {
                  Navigator.of(context).pushNamed('/tasks', arguments: widget.team);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder(
            stream: FirebaseFirestore.instance
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
                        Navigator.of(context).pushNamed('/tasks', arguments: widget.team);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainButtonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const CustomText(
                        text: "Create Task",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }

              final docs = snapshot.data!.docs;
              final tasks = docs.take(4).map((doc) =>
                  TaskModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();

              return Column(
                children: tasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.selectedTaskColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.secondary, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) async {
                              await taskController.toggleCompleted(task);
                            },
                            activeColor: AppColors.mainButtonColor,
                            checkColor: AppColors.grayTextColor,
                            side: const BorderSide(color: AppColors.secondary, width: 2),
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            text: task.title,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
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
    padding: const EdgeInsets.all(32.0),
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Let everyone to Join",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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