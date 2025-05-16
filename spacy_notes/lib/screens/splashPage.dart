import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500)); 

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await FirebaseAuth.instance.signOut(); 
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final widthScale = (screenWidth / 500).clamp(0.6, 1.0).toDouble();
    final heightScale = (screenHeight / 800).clamp(0.6, 1.0).toDouble();
    final finalScale = widthScale < heightScale ? widthScale : heightScale;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Transform.scale(
            scale: finalScale,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 300),
                  const SizedBox(height: 20),
                  const CustomText(
                    text: "SPACY NOTES",
                    fontSize: 40,
                    color: AppColors.mainTextColor,
                  ),
                  const SizedBox(height: 80),
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.mainTextColor,
                      ),
                      strokeWidth: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}