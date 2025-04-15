import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;

  const CustomAppBar({
    super.key,
    required this.title, // This is the required title parameter.
    this.onPressed, //This is an optional callback for the back button.
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary, // This is the background color of the AppBar.
      elevation: 0,
      leading: IconButton( // This is the icon button in order to go back.
        icon: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 28),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Column( // These are line and title.
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: title,color: AppColors.grayTextColor,fontSize: 32,),
          const SizedBox(height: 8), // Height between title and line.
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}