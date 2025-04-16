import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? rhs;

  const CustomAppBar({
    super.key,
    this.rhs, // This is an optional widget that can be placed on the right side of the AppBar.
    required this.title, // This is the required title parameter.
    this.onPressed, //This is an optional callback for the back button.
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
Widget build(BuildContext context) {
  return PreferredSize(
    preferredSize: preferredSize,
    child: Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only( left: 16, right: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sol: Geri butonu
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 28),
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          // Orta: Başlık ve alt çizgi
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: title,
                color: AppColors.grayTextColor,
                fontSize: 32,
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.white,
              ),
            ],
          ),
          // Sağ: rhs widget (varsa)
          if (rhs != null)
            Align(
              alignment: Alignment.centerRight,
              child: rhs!,
            ),
        ],
      ),
    ),
  );
}
}