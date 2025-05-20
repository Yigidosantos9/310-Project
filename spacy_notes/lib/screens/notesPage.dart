import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/models/notes_model.dart';
import 'package:spacy_notes/providers/notes_provider.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Tuple2<String, String>) {
      return const Scaffold(
        body: Center(child: Text('Invalid arguments provided')),
      );
    }

    final String teamId = args.item1;
    final String courseId = args.item2;

    final notesAsyncValue = ref.watch(notesProvider(Tuple2(teamId, courseId)));

    final cardColors = [
      const Color.fromARGB(255, 176, 147, 231),
      const Color.fromARGB(255, 132, 94, 188),
      const Color.fromARGB(181, 168, 91, 220),
      const Color.fromARGB(255, 132, 87, 204),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Notes',
        subTitle: 'Page',
        onPressed:
            () => Navigator.pushReplacementNamed(
              context,
              '/courses',
              arguments: teamId,
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/note',
            arguments: Tuple2(teamId, courseId),
          );
        },
      ),
      body: notesAsyncValue.when(
        data:
            (notes) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(notes.length, (index) {
                    final note = notes[index];

                    // Calculate the row index (2 cards per row)
                    final rowIndex = (index / 2).floor();

                    // Pick base color by rowIndex cycling through cardColors
                    final baseColor = cardColors[rowIndex % cardColors.length];

                    // Create gradient colors (slightly darker to lighter)
                    final gradientStart = baseColor.withOpacity(0.9);
                    final gradientEnd = baseColor.withOpacity(0.6);

                    return GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            '/note',
                            arguments: Tuple3(note, teamId, courseId),
                          ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [gradientStart, gradientEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: baseColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  'Created: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 47),
                            CustomText(
                              text: note.content,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading notes: $e')),
      ),
    );
  }
}
