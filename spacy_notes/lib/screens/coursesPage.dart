import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'dart:math';

int getRandomNumberInRange(int min, int max) {
  Random random = Random();
  return min + random.nextInt(max - min + 1);
}

Color getRandomColor() {
  final Random random = Random();
  double hue = random.nextDouble() * 360;
  double saturation = 0.6;
  double lightness = 0.8;
  final hslColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
  return hslColor.toColor();
}

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<Map<String, dynamic>> planets = [];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Courses'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPlanet,
        backgroundColor: AppColors.mainButtonColor,
        child: Icon(Icons.add, color: AppColors.iconColor),
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          InteractiveViewer(
            maxScale: 5.0,
            minScale: 0.5,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: Center(
              child: Container(
                width: 2000, // a big but finite space
                height: 2000,
                color: Colors.transparent,
                child: Stack(children: _buildPlanets()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showTextInputDialog() async {
    _textController.clear();
    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.secondaryButtonColor,
            title: const CustomText(
              text: "Enter planet label",
              color: AppColors.secondary,
            ),
            content: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Planet name...",
                hintStyle: TextStyle(
                  color: AppColors.darkSubTextColor,
                ), // Color for the hint text
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryButtonColor,
                  ), // Border color when not focused
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.mainButtonColor,
                  ), // Border color when focused
                ),
              ),
              autofocus: false,
              style: TextStyle(
                color: AppColors.mainButtonColor,
              ), // Color for the typed text
            ),
            actions: [
              TextButton(
                child: const CustomText(
                  text: "Cancel",
                  color: AppColors.secondary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const CustomText(
                  text: "Add",
                  color: AppColors.secondary,
                ),
                onPressed: () => Navigator.pop(context, _textController.text),
              ),
            ],
          ),
    );
  }

  void _addNewPlanet() async {
    String? inputText = await _showTextInputDialog();
    if (inputText == null || inputText.trim().isEmpty) return;

    const double padding = 20.0;
    const int maxAttempts = 50;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      double newTop = getRandomNumberInRange(20, 100).toDouble();
      double newLeft = getRandomNumberInRange(20, 100).toDouble();
      double newSize = getRandomNumberInRange(20, 100).toDouble();

      bool overlaps = planets.any((planet) {
        double dx = newLeft - planet['left'];
        double dy = newTop - planet['top'];
        double distance = sqrt(dx * dx + dy * dy);
        double minAllowedDistance = (newSize + planet['size']) / 2 + padding;
        return distance < minAllowedDistance;
      });

      if (!overlaps) {
        setState(() {
          planets.add({
            "color": getRandomColor(),
            "top": newTop,
            "left": newLeft,
            "size": newSize,
            "text": inputText,
          });
        });
        break;
      }
    }
  }

  List<Widget> _buildPlanets() {
    return planets
        .map(
          (planet) => Positioned(
            top: planet["top"],
            left: planet["left"],
            child: PlanetWidget(
              color: planet["color"],
              size: planet["size"],
              inputText: planet["text"],
            ),
          ),
        )
        .toList();
  }
}

class PlanetWidget extends StatelessWidget {
  final Color color;
  final double size;
  final String inputText;

  const PlanetWidget({
    super.key,
    required this.color,
    required this.size,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 30,
      height: size + 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                // You can add actions on tap here
              },
              child: FittedBox(
                child: CustomText(text: inputText, fontSize: 37),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
