import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/models/user_model.dart';
import 'package:spacy_notes/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _formatTimeWorked(int seconds) {
    final m = (seconds / 60).toInt();
    final h = m ~/ 60;
    return '$h h $m m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 360;
    final double horizontalPadding = size.width * 0.06;

    return userAsync.when(
      loading:
          () => const Scaffold(
            backgroundColor: Color.fromARGB(255, 17, 1, 37),
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (e, _) => Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text("Error: $e")),
          ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(child: Text("User not found.")),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Profile',
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ref.invalidate(userStreamProvider);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            rhs: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/market');
              },
            ),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: 1,
              backgroundColor: const Color.fromARGB(255, 17, 1, 37),
              selectedItemColor: AppColors.onSecondary,
              unselectedItemColor: AppColors.onPrimary.withOpacity(0.6),
              type: BottomNavigationBarType.fixed,
              elevation: 8,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  activeIcon: Icon(Icons.article),
                  label: 'Notes',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time_outlined),
                  activeIcon: Icon(Icons.access_time_filled),
                  label: 'Focus',
                ),
              ],
              onTap: (index) {
                if (index == 1) return;
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/groups');
                    break;

                  case 2:
                    Navigator.pushNamed(context, '/pomodoro');
                    break;
                }
              },
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.onSecondary,
              onRefresh: () async {
                ref.invalidate(userStreamProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildProfileHeader(context, user, isSmallScreen),
                    const SizedBox(height: 24),
                    _buildStatsCards(context, user),
                    const SizedBox(height: 24),
                    _buildTeamsButton(context),
                    const SizedBox(height: 32),
                    _buildBadgesSection(context),
                    const SizedBox(height: 32),
                    _buildActionButtons(context, ref),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserModel user,
    bool isSmallScreen,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.mainButtonColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      color: const Color.fromARGB(255, 17, 1, 37).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isSmallScreen
                ? Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        'assets/images/astronaut.png',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const CustomText(
                          text: 'Nickname',
                          color: AppColors.onPrimary,
                          fontSize: 18,
                          fontFamily: "jersey",
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: user.username,
                          color: AppColors.onSecondary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "jersey",
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: '${user.starPoints} S.P.',
                              color: AppColors.onPrimary,
                              fontSize: 20,
                              fontFamily: "jersey",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
                : Row(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        'assets/images/astronaut.png',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'Nickname',
                            color: AppColors.onPrimary,
                            fontSize: 18,
                            fontFamily: "jersey",
                          ),
                          CustomText(
                            text: user.username,
                            color: AppColors.onSecondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "jersey",
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: '${user.starPoints} S.P.',
                                color: AppColors.onPrimary,
                                fontSize: 20,
                                fontFamily: "jersey",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, UserModel user) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          context,
          icon: Icons.access_time,
          title: 'Time Worked',
          value: _formatTimeWorked(user.timeWorked),
          color: Colors.blue[700]!,
        ),
        _buildStatCard(
          context,
          icon: Icons.check_circle,
          title: 'Tasks Completed',
          value: '${user.tasksCompleted} / ${user.totalTasks}',
          color: Colors.green[700]!,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 17, 1, 37),
              color.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onSecondary, size: 32),
            const SizedBox(height: 12),
            CustomText(
              text: title,
              color: AppColors.onPrimary,
              fontSize: 16,
              fontFamily: "jersey",
            ),
            const SizedBox(height: 8),
            CustomText(
              text: value,
              color: AppColors.onSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "jersey",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsButton(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/teams');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromARGB(255, 17, 1, 37),
                AppColors.mainButtonColor.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: AppColors.onSecondary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const CustomText(
                    text: 'My Teams',
                    color: AppColors.onSecondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "jersey",
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.onSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgesSection(BuildContext context) {
    // Bu fonksiyon badge'leri göstermek için kullanılır
    // Badge'leri rastgele göstermek için bir liste oluşturalım
    final List<Map<String, dynamic>> badges = [
      {
        'name': 'Focus Master',
        'image': 'assets/images/badges/badge_1.svg',
        'unlocked': true,
      },
      {
        'name': 'Note Pro',
        'image': 'assets/images/badges/badge_2.svg',
        'unlocked': true,
      },
      {
        'name': 'Task Ninja',
        'image': 'assets/images/badges/badge_3.svg',
        'unlocked': true,
      },
      {
        'name': 'Time Lord',
        'image': 'assets/images/badges/badge_4.svg',
        'unlocked': false,
      },
      {
        'name': 'Space Explorer',
        'image': 'assets/images/badges/badge_5.svg',
        'unlocked': false,
      },
      {
        'name': 'Galaxy Master',
        'image': 'assets/images/badges/badge_6.svg',
        'unlocked': false,
      },
      {
        'name': 'Star Collector',
        'image': 'assets/images/badges/badge_7.svg',
        'unlocked': false,
      },
      {
        'name': 'Cosmic Writer',
        'image': 'assets/images/badges/badge_8.svg',
        'unlocked': false,
      },
      {
        'name': 'Nebula Scholar',
        'image': 'assets/images/badges/badge_9.svg',
        'unlocked': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: 'Badges',
              color: AppColors.onSecondary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "jersey",
            ),
            TextButton(
              onPressed: () {
                // Navigate to a detailed badges page
                Navigator.pushNamed(context, '/badges');
              },
              child: const CustomText(
                text: 'See All',
                color: AppColors.mainButtonColor,
                fontSize: 16,
                fontFamily: "jersey",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightSubTextColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mainButtonColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child:
              badges.isEmpty
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CustomText(
                        text: 'No badges earned yet',
                        color: AppColors.onPrimary,
                        fontSize: 16,
                        fontFamily: "jersey",
                      ),
                    ),
                  )
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        badges.length > 6
                            ? 6
                            : badges.length, // Show max 6 badges
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      final bool isUnlocked = badge['unlocked'] as bool;

                      return GestureDetector(
                        onTap: () {
                          // Badge'e tıklandığında detaylarını göster
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    17,
                                    1,
                                    37,
                                  ),
                                  title: CustomText(
                                    text: badge['name'],
                                    color: AppColors.onSecondary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "jersey",
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        badge['image'],
                                        width: 100,
                                        height: 100,
                                        colorFilter:
                                            isUnlocked
                                                ? null
                                                : const ColorFilter.mode(
                                                  Colors.grey,
                                                  BlendMode.saturation,
                                                ),
                                      ),
                                      const SizedBox(height: 16),
                                      CustomText(
                                        text:
                                            isUnlocked
                                                ? 'You\'ve earned this badge!'
                                                : 'Badge locked. Complete more tasks to unlock!',
                                        color: AppColors.onPrimary,
                                        fontSize: 16,
                                        textAlign: TextAlign.center,
                                        fontFamily: "jersey",
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const CustomText(
                                        text: 'Close',
                                        color: AppColors.mainButtonColor,
                                        fontSize: 16,
                                        fontFamily: "jersey",
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    badge['image'],
                                    width: 60,
                                    height: 60,
                                    colorFilter:
                                        isUnlocked
                                            ? null
                                            : const ColorFilter.mode(
                                              Colors.grey,
                                              BlendMode.saturation,
                                            ),
                                  ),
                                  if (!isUnlocked)
                                    const Icon(
                                      Icons.lock,
                                      color: Colors.white54,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              text: badge['name'],
                              color:
                                  isUnlocked
                                      ? AppColors.onPrimary
                                      : AppColors.onPrimary.withOpacity(0.5),
                              fontSize: 12,
                              textAlign: TextAlign.center,
                              fontFamily: "jersey",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Action for edit profile
            // Navigator.pushNamed(context, '/edit-profile');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onSecondary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: AppColors.mainButtonColor,
                width: 1.5,
              ),
            ),
          ),
          icon: const Icon(Icons.edit),
          label: const CustomText(
            text: 'Edit Profile',
            fontSize: 16,
            fontFamily: "jersey",
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              ref.invalidate(userStreamProvider);
              Navigator.pushReplacementNamed(context, '/login');
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent,
            minimumSize: const Size(double.infinity, 50),
          ),
          icon: const Icon(Icons.logout),
          label: const CustomText(
            text: 'Logout',
            fontSize: 16,
            fontFamily: "jersey",
          ),
        ),
      ],
    );
  }
}
