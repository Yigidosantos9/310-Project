import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/user_provider.dart';

final userTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null || user.joinedTeams.isEmpty) {
    return [];
  }

  final codes = user.joinedTeams;
  final teamsRef = FirebaseFirestore.instance.collection('teams');
  final List<TeamModel> teams = [];

  for (var i = 0; i < codes.length; i += 10) {
    final chunk = codes.sublist(i, i + 10 > codes.length ? codes.length : i + 10);
    final snapshot = await teamsRef.where('code', whereIn: chunk).get();
    teams.addAll(snapshot.docs.map((doc) => TeamModel.fromFirestore(doc)));
  }
  return teams;
});