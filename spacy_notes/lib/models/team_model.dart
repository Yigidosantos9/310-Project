import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamModel {
  final String id;
  final String name;
  final String description;
  final String code;
  final String createdBy;
  final Timestamp createdAt;
  final List<String> members;
  final Map<String, bool> settings;

  TeamModel({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    required this.settings,
  });

  factory TeamModel.fromMap(String id, Map<String, dynamic> data) {
    return TeamModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      code: data['code'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      members: List<String>.from(data['members'] ?? []),
      settings: Map<String, bool>.from(data['settings'] ?? {}),
    );
  }


  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    return TeamModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'code': code,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'members': members,
      'settings': settings,
    };
  }

  
  static Future<DocumentReference> createTeam({
    required String name,
    required String description,
    required User user,
    required Map<String, bool> settings,
  }) async {
    final code = const Uuid().v4().substring(0, 6);
    final teamData = TeamModel(
      id: '',
      name: name,
      description: description,
      code: code,
      createdBy: user.uid,
      createdAt: Timestamp.now(),
      members: [user.uid],
      settings: settings,
    );

    return FirebaseFirestore.instance.collection('teams').add(teamData.toMap());
  }
}