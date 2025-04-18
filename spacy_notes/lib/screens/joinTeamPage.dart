import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class JoinTeamPage extends StatefulWidget {
  const JoinTeamPage({super.key});

  @override
  State<JoinTeamPage> createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends State<JoinTeamPage> {
  final TextEditingController _teamIdController = TextEditingController();

  String? teamName;
  String? teamDescription;
  String? ownerName;

  void fetchTeamData(String id) {
    if (id.trim() == "32693") {
      setState(() {
        teamName = "Lagaluga";
        teamDescription =
            "Our team is supposed to be the best one. However, our StarPoint is not enough to buy Buzz LightYear icon.";
        ownerName = "Yigidosantos9";
      });
    } else {
      setState(() {
        teamName = null;
        teamDescription = null;
        ownerName = null;
      });
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
                      // Team ID input
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
                                fetchTeamData(_teamIdController.text);
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
                              // Icon + Name
                              Column(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: AppColors.selectedTaskColor,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: const Icon(
                                      Icons.public,
                                      size: 100,
                                      color: AppColors.mainButtonColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const CustomText(
                                    text: "Icon Name",
                                    fontSize: 30,
                                    color: AppColors.grayTextColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              // OWNER info
                              SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CustomText(
                                      text: "OWNER :",
                                      fontSize: 40,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: ownerName!,
                                      fontSize: 30,
                                      //fontWeight: FontWeight.w600,
                                      color: AppColors.grayTextColor,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      Expanded(child: Container()),

                      // Join Team Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Join Team tapped");
                            },
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
