import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';
import 'package:spacy_notes/models/notes_model.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  NoteModel? note;
  late String teamId;
  late String courseId;

  late TextEditingController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Tuple3<NoteModel, String, String>) {
      note = args.item1;
      teamId = args.item2;
      courseId = args.item3;
      _controller = TextEditingController(text: note!.content);
    } else if (args is Tuple2<String, String>) {
      teamId = args.item1;
      courseId = args.item2;
      _controller = TextEditingController(); // yeni not, içerik boş
    } else {
      throw Exception("Invalid arguments passed to NotePage");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final content = _controller.text.trim();

    final notesRef = FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('courses')
        .doc(courseId)
        .collection('notes');

    if (note != null) {
      // UPDATE işlemi
      await notesRef.doc(note!.id).update({'content': content});
    } else {
      // CREATE işlemi
      final newNoteRef = notesRef.doc(); // otomatik ID oluşturur
      await newNoteRef.set({
        'content': content,
        'createdBy': 'currentUserId', // burada auth ile gelen kullanıcıyı koymalısın
        'createdAt': Timestamp.now(),
      });
    }

    Navigator.of(context).popUntil(ModalRoute.withName('/profile'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(
          title: "Note",
          subTitle: "Page",
        ),
        body: Column(
          children: [
            // Yazı Alanı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.selectedTaskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                      hintText: "Write something...",
                      hintStyle: TextStyle(
                        color: AppColors.darkSubTextColor,
                        fontSize: 18,
                        fontFamily: "jersey",
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.onSecondary,
                      fontFamily: "jersey",
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ),
            ),

            // Kaydet / Vazgeç Butonları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(ModalRoute.withName('/profile'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        text: "Cancel",
                        fontSize: 18,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        text: "Save",
                        fontSize: 18,
                        color: AppColors.mainTextColor,
                      ),
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