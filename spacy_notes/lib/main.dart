import 'package:flutter/material.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'spicy_notes',
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
          onSurface: AppColors.onSurface)
      ),
      home: const MyHomePage(),
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
        title: Text("Spicy Notes",
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}