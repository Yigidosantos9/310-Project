import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/TeamCard.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> teams = [
              TeamCard(
                onTap: () => Navigator.of(context).pushNamed('/login'), // Details Page ile değişecek
                teamName: "Team name",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text...",
              ),
              TeamCard(
                onTap: () => Navigator.of(context).pushNamed('/detailedTeam'),
                teamName: "Team name",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text...",
              ),
              TeamCard(
                onTap: () => Navigator.of(context).pushNamed('/detailedTeam'),
                teamName: "Team name",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text...",
              ),
            ];

    return SafeArea(
    child: Scaffold(
      appBar: const CustomAppBar(title: "My Teams"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
            padding: const EdgeInsets.all(16),
            children: teams,
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/joinTeam');
                    },
                    child: const CustomText(text: "Join Team", fontSize: 18,color: AppColors.mainTextColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/createTeam');
                    },
                    child: const CustomText(text: "Create Team", fontSize: 18,color: AppColors.mainTextColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}
