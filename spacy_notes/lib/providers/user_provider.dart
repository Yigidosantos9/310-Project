import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy_notes/models/user_model.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) => UserNotifier(),
);

final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) return  Stream.value(null);

  final docRef = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
  return docRef.snapshots().map((doc) {
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data()!);
  });
});