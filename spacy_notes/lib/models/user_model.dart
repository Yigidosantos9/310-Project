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
  final int totalTasks;
  final String profilePhoto;
  final List<String> colorPalettes;
  final List<String> badges;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.joinedTeams = const [],
    this.starPoints = 0,
    this.timeWorked = 0,
    this.tasksCompleted = 0,
    DateTime? createdAt,
    this.profilePhoto = '',
    this.totalTasks = 0,
    this.colorPalettes = const [],
    this.badges = const [],
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
      profilePhoto: data['profilePhoto'] ?? '',
      colorPalettes: List<String>.from(data['colorPalettes'] ?? []),
      badges: List<String>.from(data['badges'] ?? []),
      totalTasks: data['totalTasks'] ?? 0,
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
      'profilePhoto': profilePhoto,
      'colorPalettes': colorPalettes,
      'badges': badges,
      'totalTasks': totalTasks,
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    List<String>? joinedTeams,
    int? starPoints,
    int? timeWorked,
    int? tasksCompleted,
    DateTime? createdAt,
    String? profilePhoto,
    List<String>? colorPalettes,
    List<String>? badges,
    int? totalTasks,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      joinedTeams: joinedTeams ?? this.joinedTeams,
      starPoints: starPoints ?? this.starPoints,
      timeWorked: timeWorked ?? this.timeWorked,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      createdAt: createdAt ?? this.createdAt,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      colorPalettes: colorPalettes ?? this.colorPalettes,
      badges: badges ?? this.badges,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }
}