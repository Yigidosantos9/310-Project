import 'package:flutter/material.dart';
import 'package:spacy_notes/widgets/market_widgets/item_purchase.dart';

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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 3),
            ),
          ),
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

class _CutCornersClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cutSize = 12.0;
    return Path()
      ..moveTo(cutSize, 0)
      ..lineTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(cutSize, size.height)
      ..lineTo(0, size.height - cutSize)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(_CutCornersClipper oldClipper) => false;
}

class CutCornerColorCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final List<Color> gradientColors;
  final Color circleBorderColor;
  final Color circleFillColor;

  const CutCornerColorCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.gradientColors,
    required this.circleBorderColor,
    required this.circleFillColor,
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
          child: Row(
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
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
        ),
      );
  }
}