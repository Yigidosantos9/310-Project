import 'package:flutter/material.dart';

/// A stylized card for displaying a planet item in the store.
/// Includes gradient background, image, title, subtitle, and price.
class PlanetCard extends StatelessWidget {
  final String title;       // Example: "Mercury"
  final String subTitle;    // Example: "Closest to the Sun"
  final String imagePath;   // Path to the image displayed in the center
  final String price;       // Price label (e.g. "150")

  const PlanetCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        // Slightly varied purple gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 94, 21, 139),
            const Color.fromARGB(255, 185, 69, 216),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        // Dark purple border around the card
        border: Border.all(
          color: const Color(0xFF4A148C),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Title and subtitle section at the top (NFT style using Orbitron font)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Title with inline gradient using ShaderMask
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      const Color.fromARGB(255, 228, 224, 224),
                    ],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle with inline gradient using ShaderMask
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 246, 245, 248),
                      const Color.fromARGB(255, 255, 255, 255),
                    ],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Planet image displayed in the center
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Price displayed at the bottom with gradient
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 255, 255, 255),
                    const Color.fromARGB(255, 237, 239, 240),
                  ],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  price,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
