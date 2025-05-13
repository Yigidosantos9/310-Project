import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy_notes/models/user_model.dart';
import 'package:spacy_notes/providers/user_provider.dart'; 

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final userModel = UserModel.fromMap(doc.id, doc.data()!);
      ref.read(userProvider.notifier).setUser(userModel);
      setState(() => _isLoading = false);
    }
  }

  String _formatTimeWorked(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '$h h $m m';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (_isLoading || user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Profile'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.onSecondary,
        unselectedItemColor: AppColors.onPrimary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'NewNote'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Focus'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Market'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/groups');
              break;
            case 1:
              Navigator.pushNamed(context, '/note');
              break;
            case 3:
              Navigator.pushNamed(context, '/pomodoro');
              break;
            case 4:
              Navigator.pushNamed(context, '/market');
              break;
          }
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 72,
                        backgroundImage: AssetImage('assets/images/astronaut.png'),
                      ),
                      const SizedBox(width: 48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'Nickname :',
                            color: AppColors.onPrimary,
                            fontSize: 24,
                            fontFamily: "jersey",
                          ),
                          CustomText(
                            text: user.username,
                            color: AppColors.onSecondary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: "jersey",
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'Starpoint : ${user.starPoints} S.P.',
                            color: AppColors.onPrimary,
                            fontSize: 24,
                            fontFamily: "jersey",
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: 'Time Worked : ${_formatTimeWorked(user.timeWorked)}',
                      color: AppColors.onSecondary,
                      fontSize: 28,
                      fontFamily: "jersey",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: 'Task Completed : ${user.tasksCompleted}',
                      color: AppColors.onSecondary,
                      fontSize: 28,
                      fontFamily: "jersey",
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CustomText(
                    text: 'Badges :',
                    color: AppColors.onSecondary,
                    fontSize: 28,
                    fontFamily: "jersey",
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightSubTextColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.mainButtonColor,
                        width: 2,
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return Center(
                          child: SvgPicture.asset(
                            'assets/images/badges/badge_${index + 1}.svg',
                            width: 85,
                            height: 85,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}