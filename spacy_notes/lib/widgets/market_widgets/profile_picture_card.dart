import 'package:flutter/material.dart';

class ProfilePictureCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String price;

  const ProfilePictureCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    const cardWidth = 200.0;
    const cardHeight = 270.0;
    const priceBoxHeight = 40.0; // Approximate height of the price tag

    return Container(
      margin: const EdgeInsets.all(10),
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow (for price box)
        children: [
          // Main card body with cut-corner clipping
          ClipPath(
            clipper: _CutCornerClipper(),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B4DA1), Color(0xFF4A80E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  // Title text
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Circular avatar image
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white24,
                    backgroundImage: imagePath.startsWith("http")
                        ? NetworkImage(imagePath)
                        : AssetImage(imagePath) as ImageProvider,
                  ),
                  const Spacer(), // Pushes content up for spacing
                ],
              ),
            ),
          ),

          // Price tag placed half outside the bottom
          Positioned(
            bottom: -priceBoxHeight / 2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: priceBoxHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1B47),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language,
                        color: Colors.lightBlueAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper for cut-corner shaped cards
class _CutCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 12.0;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width - cut, 0)
      ..lineTo(size.width, cut)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(cut, size.height)
      ..lineTo(0, size.height - cut)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
