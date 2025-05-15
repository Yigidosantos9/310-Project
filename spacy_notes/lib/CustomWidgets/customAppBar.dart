import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final VoidCallback? onPressed;
  final Widget? rhs;

  const CustomAppBar({
    super.key,
    this.rhs, // This is an optional widget that can be placed on the right side of the AppBar.
    this.subTitle, // This is an optional subtitle.
    required this.title, // This is the required title parameter.
    this.onPressed, //This is an optional callback for the back button.
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
Widget build(BuildContext context) {
  return /*PreferredSize(
    preferredSize: preferredSize,
    child: Container(
      color: AppColors.appBarColor,
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
}*/AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 1, 37),
        leading: const CloseButton(),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                // 'Spacy ' kısmı gradient ile
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [Color(0xFF5B2C6F), Color(0xFF9B59B6)],
                        ).createShader(bounds),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // 'Store' kısmı da gradient veya beyaz olarak
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 232, 229, 233),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ).createShader(bounds),
                    child: Text(
                      subTitle!=null ? " $subTitle":'',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                rhs?? SizedBox(width: 30,),
              ],
            ),
          ),
        ],
      );
}}