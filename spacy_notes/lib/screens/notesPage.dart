import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> notes = [
    {
      'title': 'Week 1\nHomo Sapiens',
      'content': 'Around 10.000 years ago, 6 types of humans lived...',
      'color': '0xFFFFA726',
    },
    {
      'title': 'Triangular Trade System',
      'content': 'This was called a "Triangular" trade system...',
      'color': '0xFFFFB74D',
    },
  ];

  void _goToNotePage() async {
    final newNote = await Navigator.pushNamed(context, '/note');

    if (newNote != null && newNote is Map<String, String>) {
      setState(() {
        notes.add(newNote);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'NOTES',
        onPressed: () => Navigator.pushReplacementNamed(context, '/courses'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _goToNotePage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              notes.map((note) {
                return GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        '/note',
                        arguments: note,
                      ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    constraints: const BoxConstraints(maxHeight: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(int.parse(note['color']!)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: note['title']!,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: note['content']!,
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
    );
  }
}
