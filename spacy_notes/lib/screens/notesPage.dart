import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/models/notes_model.dart';
import 'package:spacy_notes/providers/notes_provider.dart';

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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'NOTES',
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
          final newNote = await Navigator.pushNamed(
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
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    notes.map((note) {
                      final randomColor =
                          Colors.primaries[note.createdAt.second %
                              Colors.primaries.length];
                      return GestureDetector(
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/note',
                              arguments: Tuple3(note, teamId, courseId),
                            ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          constraints: const BoxConstraints(maxHeight: 300),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: randomColor.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    'Created: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: note.content,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading notes: $e')),
      ),
    );
  }
}
