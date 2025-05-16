import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/user_provider.dart';
import 'package:async/async.dart'; // 👈 StreamZip için gerekli!

final userTeamsStreamProvider = StreamProvider<List<TeamModel>>((ref) {
  final user = ref.watch(userStreamProvider).value;
  if (user == null || user.joinedTeams.isEmpty) {
    return const Stream.empty();
  }

  final codes = user.joinedTeams;
  final teamsRef = FirebaseFirestore.instance.collection('teams');

  final List<Stream<List<TeamModel>>> teamStreams = [];

  // Firestore'da "whereIn" maksimum 10 değer alabilir.
  for (var i = 0; i < codes.length; i += 10) {
    final chunk = codes.sublist(i, i + 10 > codes.length ? codes.length : i + 10);

    final stream = teamsRef
        .where('code', whereIn: chunk)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TeamModel.fromFirestore(doc)).toList());

    teamStreams.add(stream);
  }

  // Çoklu stream'leri tek stream'e çeviriyoruz
  return StreamZip(teamStreams).map((listOfLists) {
    return listOfLists.expand((x) => x).toList();
  });
});