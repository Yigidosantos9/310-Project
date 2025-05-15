import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/group_provider.dart';
import 'package:spacy_notes/providers/user_provider.dart';

class CreateTeamPage extends ConsumerStatefulWidget {
  const CreateTeamPage({super.key});

  @override
  ConsumerState<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends ConsumerState<CreateTeamPage> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescController = TextEditingController();
  bool canBeSeen = true;
  bool canChangeIcon = true;
  bool canChangeDescName = true;
  String? generatedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'CREATE TEAM'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: AppColors.selectedTaskColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.public,
                                  size: 72,
                                  color: AppColors.mainButtonColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const CustomText(
                                text: "Icon Name",
                                fontSize: 18,
                                color: AppColors.grayTextColor,
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: "Team Name :",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grayTextColor,
                                ),
                                TextField(
                                  controller: _teamNameController,
                                  cursorColor: AppColors.mainButtonColor,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.lightSubTextColor,
                                    fontFamily: 'Jersey',
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your team name",
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Jersey',
                                      color: AppColors.darkSubTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const CustomText(
                                  text: "Team Description :",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grayTextColor,
                                ),
                                TextField(
                                  controller: _teamDescController,
                                  cursorColor: AppColors.mainButtonColor,
                                  maxLines: null,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Jersey',
                                    color: AppColors.lightSubTextColor,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "Enter a description of your team",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Jersey',
                                      color: AppColors.darkSubTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.selectedTaskColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomText(
                          text:
                              generatedCode != null
                                  ? "- $generatedCode -"
                                  : "- CODE -",
                          fontSize: 26,
                          color: AppColors.darkSubTextColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const CustomText(
                        text: "Settings :",
                        fontSize: 26,
                        color: AppColors.grayTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildToggleRow(
                        "Can be seen by anyone",
                        canBeSeen,
                        (val) => setState(() => canBeSeen = val),
                      ),
                      _buildToggleRow(
                        "Group members can change the icon",
                        canChangeIcon,
                        (val) => setState(() => canChangeIcon = val),
                      ),
                      _buildToggleRow(
                        "Group members can change the\ndescription and the name",
                        canChangeDescName,
                        (val) => setState(() => canChangeDescName = val),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: _createTeam,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const CustomText(
                            text: "Create Team",
                            fontSize: 40,
                            color: AppColors.mainTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.selectedTaskColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomText(
                  text: label,
                  fontSize: 17,
                  color: AppColors.darkSubTextColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.mainButtonColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.secondaryButtonColor,
          ),
        ],
      ),
    );
  }

  Future<void> _createTeam() async {
  final name = _teamNameController.text.trim();
  final description = _teamDescController.text.trim();
  final user = FirebaseAuth.instance.currentUser;
  if (name.isEmpty || user == null) return;

  final teamDoc = await TeamModel.createTeam(
    name: name,
    description: description,
    user: user,
    settings: {
      'canBeSeen': canBeSeen,
      'canChangeIcon': canChangeIcon,
      'canChangeDescName': canChangeDescName,
    },
  );

  final codeFromDB = (await teamDoc.get())['code'] as String;

  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'joinedTeams': FieldValue.arrayUnion([codeFromDB]),
  });

  final currentUser = ref.read(userProvider);
  if (currentUser != null) {
    final updatedUser = currentUser.copyWith(
      joinedTeams: [...currentUser.joinedTeams, codeFromDB],
    );
    ref.read(userProvider.notifier).setUser(updatedUser);
    print("userProvider güncellendi: ${updatedUser.joinedTeams}");
  }

  ref.read(currentGroupIdProvider.notifier).state = teamDoc.id;

  // 6️⃣ Görev sayfasına yönlendir
  Navigator.pushNamed(context, '/teams');
  }
}
