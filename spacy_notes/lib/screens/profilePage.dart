import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'NewNote',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Market',
          ),
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
                      CircleAvatar(
                        radius: 72,
                        backgroundImage: AssetImage(
                          'assets/images/astronaut.png',
                        ),
                      ),
                      const SizedBox(width: 48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CustomText(
                            text: 'Nickname :',
                            color: AppColors.onPrimary,
                            fontSize: 24,
                            fontFamily: "jersey",
                          ),
                          CustomText(
                            text: 'Nikomik06',
                            color: AppColors.onSecondary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: "jersey",
                          ),
                          SizedBox(height: 4),
                          CustomText(
                            text: 'Starpoint : 78 S.P.',
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
                    child: const CustomText(
                      text: 'Time Worked :    13 h 48 m',
                      color: AppColors.onSecondary,
                      fontSize: 28,
                      fontFamily: "jersey",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: const CustomText(
                      text: 'Task Completed :    10 / 14',
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
