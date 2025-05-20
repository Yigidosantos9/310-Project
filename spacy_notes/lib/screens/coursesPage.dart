import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'dart:math';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:tuple/tuple.dart';
import 'package:spacy_notes/models/courses_model.dart';
import 'package:spacy_notes/providers/courses_provider.dart';

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

class CoursesPage extends ConsumerStatefulWidget {
  const CoursesPage({super.key});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  String? teamId;

  final TextEditingController _textController = TextEditingController();

  final double canvasSize = 1000;
  final double margin = 100;
  final double padding = 20.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      teamId = args;
    } else {
      teamId = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = 'your-user-id';
    final courseAsyncValue = ref.watch(courseListProvider(teamId!));

    return Scaffold(
      appBar: const CustomAppBar(title: "Courses", subTitle: 'Page'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCourse,
        backgroundColor: AppColors.mainButtonColor,
        child: Icon(Icons.add, color: AppColors.iconColor),
      ),
      backgroundColor: AppColors.background,
      body: courseAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (courses) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: StarFieldPainter(starCount: 150)),
              ),
              InteractiveViewer(
                constrained: false,
                maxScale: 5.0,
                minScale: 0.5,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: Center(
                  child: SizedBox(
                    width: canvasSize,
                    height: canvasSize,
                    child: Stack(
                      children:
                          courses.map((course) {
                            final double top =
                                getRandomNumberInRange(100, 800).toDouble();
                            final double left =
                                getRandomNumberInRange(100, 800).toDouble();
                            final double size =
                                getRandomNumberInRange(60, 120).toDouble();
                            final color = getRandomColor();

                            return Positioned(
                              top: top,
                              left: left,
                              child: PlanetWidget(
                                color: color,
                                size: size,
                                inputText: course.name,
                                courseId: course.id,
                                teamId: teamId!,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
                hintStyle: TextStyle(color: AppColors.darkSubTextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryButtonColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainButtonColor),
                ),
              ),
              style: TextStyle(color: AppColors.mainButtonColor),
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

  void _addNewCourse() async {
    final String? inputText = await _showTextInputDialog();
    if (inputText == null || inputText.trim().isEmpty) return;

    final userId = 'your-user-id';
    final addCourse = ref.read(addCourseProvider);
    final newCourse = Course(id: UniqueKey().toString(), name: inputText);

    await addCourse(teamId!, newCourse);

    ref.invalidate(courseListProvider(teamId!));
  }
}

class PlanetWidget extends StatelessWidget {
  final Color color;
  final double size;
  final String inputText;
  final String courseId;
  final String teamId;

  const PlanetWidget({
    super.key,
    required this.color,
    required this.size,
    required this.inputText,
    required this.courseId,
    required this.teamId,
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
                Navigator.pushNamed(
                  context,
                  "/notes",
                  arguments: Tuple2(teamId, courseId),
                );
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

class StarFieldPainter extends CustomPainter {
  final int starCount;
  final Random _random = Random();

  StarFieldPainter({this.starCount = 100});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);

    for (int i = 0; i < starCount; i++) {
      final dx = _random.nextDouble() * size.width;
      final dy = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
