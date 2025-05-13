import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final List<String> joinedTeams;
  final int starPoints;
  final int timeWorked;
  final int tasksCompleted;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.joinedTeams = const [],
    this.starPoints = 0,
    this.timeWorked = 0,
    this.tasksCompleted = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      joinedTeams: List<String>.from(data['joinedTeams'] ?? []),
      starPoints: data['starPoints'] ?? 0,
      timeWorked: data['timeWorked'] ?? 0,
      tasksCompleted: data['tasksCompleted'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'joinedTeams': joinedTeams,
      'starPoints': starPoints,
      'timeWorked': timeWorked,
      'tasksCompleted': tasksCompleted,
      'createdAt': createdAt,
    };
  }
}
