import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/models/user_model.dart';

// Notifier sınıfı
class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

// Provider tanımı
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) => UserNotifier(),
);
