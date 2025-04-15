import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'loginPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Genişlik ve yükseklik oranlarını hesapla
    final widthScale = (screenWidth / 500).clamp(0.6, 1.0).toDouble();
    final heightScale = (screenHeight / 800).clamp(0.6, 1.0).toDouble();

    // En küçük oranı al: hem taşmayı engeller hem orantılı küçültür
    final finalScale = widthScale < heightScale ? widthScale : heightScale;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Transform.scale(
            scale: finalScale,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                  ),
                  const SizedBox(height: 20),
                  const CustomText(
                      text: "SPACY NOTES",
                      fontSize: 40,
                      color: AppColors.mainTextColor),
                  const SizedBox(height: 80),
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 6,
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
