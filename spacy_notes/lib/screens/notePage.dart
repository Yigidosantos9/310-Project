import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/CustomWidgets/popUpFoldersMenu.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Note Page",
          rhs: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: PopUpFolderMenu(),
          )
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.selectedTaskColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    
                    expands: true, 
                    maxLines: null, 
                    minLines: null, 
                    decoration: const InputDecoration(
                      hintText: "Write something...",
                      hintStyle: TextStyle(
                        color: AppColors.darkSubTextColor, // kendi tanımladığın renk
                      ),
                      border: InputBorder.none, 
                      contentPadding: EdgeInsets.all(16),
                    ),
                    style: const TextStyle(fontSize: 18, color: AppColors.darkSubTextColor),
                    textAlignVertical: TextAlignVertical.top, 
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: 100,
                //color: AppColors.mainButtonColor,
                decoration: BoxDecoration(
                  color: AppColors.selectedTaskColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                          color: AppColors.secondary, // 💥 işte bu border color
                          width: 2,              // kalınlık
                        ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                            'assets/images/teamIcon.png',
                            width: 20,
                          ),
                        )
                    ),
                  Container(width: 2,height: 75, color: AppColors.unselectedTaskColor,),
                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          //color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                          
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, 
                            padding: const EdgeInsets.only(left: 10),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onDoubleTap: () {
                                  // Handle double tap
                                  print("Double tapped on item $index");
                                },
                                child: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/singleTeamIcon.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
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