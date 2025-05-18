import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy_notes/models/courses_model.dart';

final courseListProvider = FutureProvider.family<List<Course>, String>((
  ref,
  teamId,
) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .collection('courses')
          .get();

  return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
});

final addCourseProvider =
    Provider<Future<void> Function(String teamId, Course)>((ref) {
      return (String teamId, Course course) async {
        final docRef = FirebaseFirestore.instance
            .collection('teams')
            .doc(teamId)
            .collection('courses')
            .doc(course.id);

        await docRef.set(course.toMap());
      };
    });
