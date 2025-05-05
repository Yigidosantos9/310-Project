// lib/services/dummy_market_service.dart
import 'package:flutter/material.dart';
import 'package:spacy_notes/providers/market_providers/market_models.dart';

abstract class MarketDataService {
  Future<List<Planet>> fetchPlanets();
  Future<List<ProfilePicture>> fetchProfiles();
  Future<List<ColorPalette>> fetchPalettes();
}

class DummyMarketService extends MarketDataService {
  @override
  Future<List<Planet>> fetchPlanets() async {
    return [
      Planet(title: "Mercury", subTitle: "Closest to the Sun", imagePath: "assets/images/logo.png", price: "150"),
      Planet(title: "Venus", subTitle: "The Morning Star", imagePath: "assets/images/logo.png", price: "200"),
      Planet(title: "Earth", subTitle: "Blue Planet", imagePath: "assets/images/logo.png", price: "250"),
      Planet(title: "Mars", subTitle: "Red Planet", imagePath: "assets/images/logo.png", price: "300"),
      Planet(title: "Jupiter", subTitle: "Gas Giant", imagePath: "assets/images/logo.png", price: "350"),
      Planet(title: "Saturn", subTitle: "Ringed Beauty", imagePath: "assets/images/logo.png", price: "400"),
    ];
  }

  @override
  Future<List<ProfilePicture>> fetchProfiles() async {
    return [
      ProfilePicture(title: "Alice", imagePath: "assets/images/logo.png", price: "500"),
      ProfilePicture(title: "Bob", imagePath: "assets/images/logo.png", price: "500"),
      ProfilePicture(title: "Charlie", imagePath: "assets/images/logo.png", price: "500"),
      ProfilePicture(title: "Dave", imagePath: "assets/images/logo.png", price: "500"),
    ];
  }

  @override
  Future<List<ColorPalette>> fetchPalettes() async {
    return [
      ColorPalette(
        title: "Dusk Horizon",
        subTitle: "Prismatic",
        gradientColors: [const Color(0xFF3E2723), const Color(0xFF1B1B1B)],
        circleBorderColor: Colors.orange,
        circleFillColor: Colors.orange,
      ),
      ColorPalette(
        title: "Neon Rider",
        subTitle: "Prismatic",
        gradientColors: [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
        circleBorderColor: Colors.orangeAccent,
        circleFillColor: Colors.orangeAccent,
      ),
      ColorPalette(
        title: "Neon Rider",
        subTitle: "Prismatic",
        gradientColors: [
          const Color.fromARGB(255, 87, 194, 180),
          const Color.fromARGB(255, 27, 105, 125),
        ],
        circleBorderColor: Colors.orangeAccent,
        circleFillColor: Colors.orangeAccent,
      ),
      ColorPalette(
        title: "Neon Rider",
        subTitle: "Prismatic",
        gradientColors: [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
        circleBorderColor: Colors.orangeAccent,
        circleFillColor: Colors.orangeAccent,
      ),
      ColorPalette(
        title: "Neon Rider",
        subTitle: "Prismatic",
        gradientColors: [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
        circleBorderColor: Colors.orangeAccent,
        circleFillColor: Colors.orangeAccent,
      ),
    ];
  }
}
