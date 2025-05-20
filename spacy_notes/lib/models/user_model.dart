import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final int balance;
  final List<String> joinedTeams;
  final int starPoints;
  final int timeWorked;
  final int tasksCompleted;
  final DateTime createdAt;
  final int totalTasks;
  final String profilePhoto;
  final List<String> purchasedPalettes;
  final List<String> purchasedProfiles;
  final List<String> purchasedPlanets;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.balance,
    this.joinedTeams = const [],
    this.starPoints = 0,
    this.timeWorked = 0,
    this.tasksCompleted = 0,
    DateTime? createdAt,
    this.profilePhoto = '',
    this.totalTasks = 0,
    required this.purchasedPalettes,
    required this.purchasedProfiles,
    required this.purchasedPlanets,
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
      balance: data['balance'] as int? ?? 0,
      purchasedPalettes: List<String>.from(data['purchasedPalettes'] ?? []),
      purchasedProfiles: List<String>.from(data['purchasedProfiles'] ?? []),
      purchasedPlanets: List<String>.from(data['purchasedPlanets'] ?? []),
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
      'balance': balance,
      'purchasedPalettes': purchasedPalettes,
      'purchasedProfiles': purchasedProfiles,
      'purchasedPlanets': purchasedPlanets,
      'totalTasks': totalTasks,
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    int? balance,
    List<String>? joinedTeams,
    int? starPoints,
    int? timeWorked,
    int? tasksCompleted,
    DateTime? createdAt,
    String? profilePhoto,
    List<String>? purchasedPalettes,
    List<String>? purchasedProfiles,
    List<String>? purchasedPlanets,
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
      balance: balance ?? this.balance,
      purchasedPalettes: purchasedPalettes ?? this.purchasedPalettes,
      purchasedProfiles: purchasedProfiles ?? this.purchasedProfiles,
      purchasedPlanets: purchasedPlanets ?? this.purchasedPlanets,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }
}