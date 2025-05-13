import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/providers/group_provider.dart';

class JoinTeamPage extends ConsumerStatefulWidget {
  const JoinTeamPage({super.key});

  @override
  ConsumerState<JoinTeamPage> createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends ConsumerState<JoinTeamPage> {
  final TextEditingController _teamIdController = TextEditingController();

  String? teamName;
  String? teamDescription;
  String? ownerName;
  String? matchedTeamId;

  Future<void> fetchTeamData(String code) async {
    final query =
        await FirebaseFirestore.instance
            .collection('teams')
            .where('code', isEqualTo: code)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      setState(() {
        matchedTeamId = doc.id;
        teamName = doc['name'];
        teamDescription = doc['description'];
        ownerName = doc['createdBy'];
      });
    } else {
      setState(() {
        matchedTeamId = null;
        teamName = null;
        teamDescription = null;
        ownerName = null;
      });
    }
  }

  Future<void> joinTeam() async {
    if (matchedTeamId != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final teamRef = FirebaseFirestore.instance
          .collection('teams')
          .doc(matchedTeamId);
      await teamRef.update({
        'members': FieldValue.arrayUnion([user.uid]),
      });

      ref.read(currentGroupIdProvider.notifier).state = matchedTeamId;
      Navigator.pushNamed(context, '/tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'JOIN TEAM'),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.selectedTaskColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _teamIdController,
                                style: const TextStyle(
                                  fontFamily: 'Jersey',
                                  fontSize: 40,
                                  color: AppColors.darkSubTextColor,
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "# Enter Team Code",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Jersey',
                                    fontSize: 35,
                                    color: AppColors.darkSubTextColor,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                size: 36,
                                color: AppColors.mainButtonColor,
                              ),
                              onPressed: () {
                                fetchTeamData(_teamIdController.text.trim());
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (teamName != null)
                        _buildInfoBox(
                          context,
                          text: teamName!,
                          icon: Icons.mail_outline,
                          fontSize: 28,
                          centerText: true,
                        ),
                      if (teamName != null) const SizedBox(height: 28),
                      if (teamDescription != null)
                        _buildInfoBox(
                          context,
                          text: teamDescription!,
                          icon: Icons.info_outline,
                          fontSize: 18,
                          isDescription: true,
                          centerText: false,
                          maxLines: null,
                        ),
                      if (ownerName != null) const SizedBox(height: 36),
                      if (ownerName != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: AppColors.selectedTaskColor,
                                      borderRadius: BorderRadius.circular(24),
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
                                    fontSize: 22,
                                    color: AppColors.grayTextColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CustomText(
                                      text: "OWNER :",
                                      fontSize: 28,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: ownerName!,
                                      fontSize: 22,
                                      color: AppColors.grayTextColor,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: joinTeam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const CustomText(
                              text: "Join Team",
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
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

  Widget _buildInfoBox(
    BuildContext context, {
    required String text,
    required IconData icon,
    double fontSize = 22,
    bool isDescription = false,
    bool centerText = false,
    int? maxLines,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.selectedTaskColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomText(
              text: text,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.darkSubTextColor,
              textAlign: centerText ? TextAlign.center : TextAlign.left,
              maxLines: maxLines,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(width: 16),
          Center(child: Icon(icon, size: 40, color: AppColors.mainButtonColor)),
        ],
      ),
    );
  }
}
