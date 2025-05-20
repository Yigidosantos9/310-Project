import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/providers/market_providers/dummy_market_to_firebase_service.dart';

// Sayfalar
import 'screens/splashPage.dart';
import 'screens/loginPage.dart';
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
import 'screens/market_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCTV94FNhfftqzcMFgsS6CyI-8dLBYlMtM",
        authDomain: "spacynotes.firebaseapp.com",
        projectId: "spacynotes",
        storageBucket: "spacynotes.firebasestorage.app",
        messagingSenderId: "825880585012",
        appId: "1:825880585012:web:c6a954f7d817fff7667b61",
        measurementId: "G-FC4LT924BE",
      ),
    );

    // Upload market values to firestore
    // await uploadDummyMarketDataToFirebase(); 
  } else {
    await Firebase.initializeApp();

    // await uploadDummyMarketDataToFirebase(); 

  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spacy Notes',
      theme: ThemeData(
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
          onSurface: AppColors.onSurface,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
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
        '/market': (context) => const MarketPage(),
      },
    );
  }
}
