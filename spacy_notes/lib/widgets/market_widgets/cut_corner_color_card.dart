import 'package:flutter/material.dart';

/// A circular icon with half-filled color on the left side.
/// Commonly used to represent item rarity or type visually.
class _HalfCircleIcon extends StatelessWidget {
  final double size;
  final Color borderColor;
  final Color fillColor;

  const _HalfCircleIcon({
    required this.size,
    required this.borderColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Outer circle with border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 3),
            ),
          ),
          // Half-filled effect using clipping
          ClipRect(
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fillColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper that trims corners to give a "cut" shape effect on all 4 sides.
class _CutCornersClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cutSize = 12.0;

    Path path = Path()
      ..moveTo(cutSize, 0)
      ..lineTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(cutSize, size.height)
      ..lineTo(0, size.height - cutSize)
      ..lineTo(0, cutSize)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(_CutCornersClipper oldClipper) => false;
}

/// Custom styled card with:
/// - cut-corner border style
/// - dynamic gradient background
/// - left circular icon (half-filled)
/// - right-side info icon (clickable)
class CutCornerColorCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final List<Color> gradientColors;
  final Color circleBorderColor;
  final Color circleFillColor;
  final VoidCallback? onInfoPressed;

  const CutCornerColorCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.gradientColors,
    required this.circleBorderColor,
    required this.circleFillColor,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CutCornersClipper(),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Info icon at top-right corner
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: onInfoPressed ?? () {},
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Left circle + title & subtitle text
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                _HalfCircleIcon(
                  size: 30,
                  borderColor: circleBorderColor,
                  fillColor: circleFillColor,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title (e.g. "Neon Rider")
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Subtitle (e.g. "Prismatic")
                    Text(
                      subTitle,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
