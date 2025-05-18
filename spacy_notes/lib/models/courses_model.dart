import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(id: doc.id, name: data['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
