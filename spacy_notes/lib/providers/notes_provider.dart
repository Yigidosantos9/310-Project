import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../models/notes_model.dart';

final notesProvider =
    StreamProvider.family<List<NoteModel>, Tuple2<String, String>>((
      ref,
      params,
    ) {
      final teamId = params.item1;
      final courseId = params.item2;

      final notesRef = FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .collection('courses')
          .doc(courseId)
          .collection('notes')
          .orderBy('createdAt', descending: true);

      return notesRef.snapshots().map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
                .toList(),
      );
    });
