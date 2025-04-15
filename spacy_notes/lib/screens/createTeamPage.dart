import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  bool canBeSeen = true;
  bool canChangeIcon = true;
  bool canChangeDescName = true;

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
                      // ICON + TEXT
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
                                  color: AppColors.iconColor,
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
                              children: const [
                                CustomText(
                                  text: "Team Name :",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grayTextColor,
                                ),
                                CustomText(
                                  text: "Lagaluga",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightSubTextColor,
                                ),
                                SizedBox(height: 16),
                                CustomText(
                                  text: "Team Description :",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grayTextColor,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Our team is supposed to be the best one. However, our StarPoint is not enough to buy Buzz LightYear icon.",
                                  style: TextStyle(
                                    color: AppColors.lightSubTextColor,
                                    fontSize: 18,
                                    fontFamily: 'Jersey',
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ID Box
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.darkPurpleColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CustomText(
                          text: "- 32693 -",
                          fontSize: 26,
                          color: AppColors.mainTextColor,
                        ),
                      ),

                      const SizedBox(height: 32),

                      const CustomText(
                        text: "Settings :",
                        fontSize: 26,
                        color: AppColors.grayTextColor,
                      ),

                      const SizedBox(height: 20),
                      _buildToggleRow("Can be seen by anyone", canBeSeen, (
                        val,
                      ) {
                        setState(() => canBeSeen = val);
                      }),
                      _buildToggleRow(
                        "Group members can change the icon",
                        canChangeIcon,
                        (val) {
                          setState(() => canChangeIcon = val);
                        },
                      ),
                      _buildToggleRow(
                        "Group members can change the\ndescription and the name",
                        canChangeDescName,
                        (val) {
                          setState(() => canChangeDescName = val);
                        },
                      ),
                      const SizedBox(height: 15),
                      // Create Team Button
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            print("Create Team tapped");
                          },
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
                color: AppColors.darkPurpleColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomText(
                  text: label,
                  fontSize: 17,
                  color: AppColors.mainTextColor,
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
}
