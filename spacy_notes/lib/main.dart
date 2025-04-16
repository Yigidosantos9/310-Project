import 'package:flutter/material.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

// Splash & Auth
import 'screens/splashPage.dart';
import 'screens/loginPage.dart';

// Ana Sayfalar
import 'screens/profilePage.dart';
import 'screens/createTeamPage.dart';
import 'screens/joinTeamPage.dart';
import 'screens/tasksPage.dart';
import 'screens/groupsPage.dart';
import 'screens/notesPage.dart';
import 'screens/coursesPage.dart';
import 'screens/notePage.dart';
import 'screens/detailedTeamPage.dart';
import 'screens/teamsPage.dart';
import 'screens/pomodoroPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      title: 'spacy_notes',
      theme: ThemeData(

          // If you don't give a specific color these
          // colors are asigned to your widget for their roles
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme(
              brightness: AppColors.brightness,
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              secondary: AppColors.secondary,
              onSecondary: AppColors.onSecondary,
              error: AppColors.error,
              onError: AppColors.onError,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface)),
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/createTeam': (context) => const CreateTeamPage(),
        '/joinTeam': (context) => const JoinTeamPage(),
        '/tasks': (context) => const TasksPage(),
        '/groups': (context) => const GroupsPage(),
        '/notes': (context) => const NotesPage(),
        '/courses': (context) => const CoursesPage(),
        '/note': (context) => const NotePage(),
        '/teamName': (context) => const TeamNamePage(),
        '/teams': (context) => const TeamsPage(),
        '/pomodoro': (context) => const PomodoroPage(),
        '/detailedTeam': (context) => const TeamNamePage(),
      },
    );
  }
}

// If you want you can change this widget this is just for trying something
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Spacy Notes",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
