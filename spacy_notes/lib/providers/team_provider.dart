import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Kullanıcının joinedTeams listesini getirir
Future<List<String>> fetchJoinedTeamCodes(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data();
  if (data == null || !data.containsKey('joinedTeams')) return [];
  return List<String>.from(data['joinedTeams']);
}

/// joinedTeams kodlarına göre teams collection'dan eşleşen team'leri alır
Future<List<Map<String, dynamic>>> fetchTeamsByCodes(List<String> codes) async {
  final teamsRef = FirebaseFirestore.instance.collection('teams');
  final List<Map<String, dynamic>> teams = [];

  for (var i = 0; i < codes.length; i += 10) {
    final chunk = codes.sublist(i, i + 10 > codes.length ? codes.length : i + 10);
    final snapshot = await teamsRef.where('code', whereIn: chunk).get();
    for (var doc in snapshot.docs) {
      teams.add(doc.data());
    }
  }

  return teams;
}

/// Provider: kullanıcıya ait takım listesini getirir
final userTeamsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];
  final codes = await fetchJoinedTeamCodes(user.uid);
  return await fetchTeamsByCodes(codes);
});