import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String description;
  final Function()? onTap;

  const TeamCard({
    super.key,
    this.onTap,
    required this.teamName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.selectedTaskColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double size = constraints.maxWidth;
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: teamName,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text: description,
                    fontSize: 18,
                    maxLines: 3,
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