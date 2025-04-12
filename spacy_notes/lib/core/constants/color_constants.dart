import 'package:flutter/material.dart';



class AppColors {
  // General color palet

  // This part is for color scheme in the material app
  // If you want to change color scheme just change in here
  // so this changes affect the entire application

  // primary Color of the app 
  static const Color primary = Color(0xFF0D0D0D);  
  // Color that on the primary color (Texts, icons ...) 
  static const Color onPrimary = Colors.white; 

  // Secondary color of the app
  static const Color secondary = Color(0xFF1E88E5);   
  // Color that on the secondary color (Texts, icons ...) 
  static const Color onSecondary = Colors.white;

  // General background color
  static const Color background = Color(0xFF121212);   

  // General error colors  
  static const Color error = Colors.redAccent;  
  static const Color onError = Colors.white;   

  // General surface theme  
  static const Color surface = Color(0xFF1C1C1C);      
  static const Color onSurface = Colors.white70; 

  // General app theme (dark or bright now)     
  static const Brightness brightness = Brightness.dark; 


  // With this you can use this class without create an instance
  AppColors._();
}