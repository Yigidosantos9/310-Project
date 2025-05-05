import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class TeamNamePage extends StatelessWidget {
  const TeamNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: CustomAppBar(title: "Team Name"),
  body: SingleChildScrollView(
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20,0,20,20),
          child: _DescriptionCard(),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(20,0,20,20),
          child: MembersSection(),
        ),
        _TasksSection(),
        const SizedBox(height: 16),
        _SettingsSection(),
      ],
    ),
  ),
);
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard();

  @override
  Widget build(BuildContext context) {
    List<bool> switches = [true, false, true, false];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.selectedTaskColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.secondary, 
          width: 2,              
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: CustomText(text: "- Description -",color: AppColors.mainButtonColor,)),
          const SizedBox(height: 8),
          CustomText(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text",fontSize: 18,),
        ],
      ),
    );
  }
}
class MembersSection extends StatefulWidget {
  const MembersSection({super.key});

  @override
  State<MembersSection> createState() => _MembersSectionState();
}

class _MembersSectionState extends State<MembersSection> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> members = [
    "Lotti", "Santos", "Ada", "Mira",
    "Kai", "Zane", "Nora", "Eren"
  ];

  List<List<String>> get chunked {
    List<List<String>> pages = [];
    for (int i = 0; i < members.length; i += 4) {
      pages.add(members.sublist(i, (i + 4).clamp(0, members.length)));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.selectedTaskColor,
              border: Border.all(
                color: AppColors.secondary, 
                width: 2,              
              ),
            ),
            height: 450,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomText(text:"- Members -",color: AppColors.mainButtonColor,),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: chunked.length,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemBuilder: (context, pageIndex) {
                        final items = chunked[pageIndex];
                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(4, (i) {
                            if (i >= items.length) return const SizedBox();
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.unselectedTaskColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                CustomText(text: items[i], fontSize: 18, color: AppColors.mainButtonColor),
                              ],
                            );
                          }),
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
          children: List.generate(chunked.length, (index) {
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


class _TasksSection extends StatefulWidget {
  const _TasksSection({super.key});

  @override
  State<_TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<_TasksSection> {
  List<String> tasks = [
    "Finish report",
    "Team meeting",
    "Code review",
    "Send email",
  ];

  List<bool> completed = [false, true, false, true];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Başlık satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "- Tasks -", color: AppColors.selectedTaskColor),
              GestureDetector(
                child: CustomText(text: "All", color: AppColors.selectedTaskColor),
                onTap: () {
                  Navigator.of(context).pushNamed('/tasks');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Task listesi
          ...List.generate(tasks.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.selectedTaskColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.secondary,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Checkbox(
                        value: completed[index],
                        onChanged: (value) {
                          setState(() => completed[index] = value ?? false);
                        },
                        activeColor: AppColors.mainButtonColor,
                        checkColor: AppColors.grayTextColor,
                        side: const BorderSide( 
                          color: AppColors.secondary,   
                          width: 2,            
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: tasks[index],
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatefulWidget {
  
  const _SettingsSection({super.key});

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  List<bool> switches= [true, false, true, false];
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
      children: List.generate(switches.length, (index) {
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
    )
    );
  }
}