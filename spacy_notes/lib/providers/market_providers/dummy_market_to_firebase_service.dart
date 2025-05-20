import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacy_notes/providers/market_providers/dummy_market_service.dart';



Future<void> uploadDummyMarketDataToFirebase() async {
  final firestore = FirebaseFirestore.instance;
  final service = DummyMarketService();

  final planets = await service.fetchPlanets();
  final profiles = await service.fetchProfiles();
  final palettes = await service.fetchPalettes();


  for (final planet in planets) {
    await firestore.collection('market/planets/items').add({
      'title': planet.title,
      'subTitle': planet.subTitle,
      'imagePath': planet.imagePath,
      'price': int.parse(planet.price), 
    });
  }

 
  for (final profile in profiles) {
    await firestore.collection('market/profiles/items').add({
      'title': profile.title,
      'imagePath': profile.imagePath,
      'price': int.parse(profile.price),
    });
  }

 
  for (final palette in palettes) {
    await firestore.collection('market/palettes/items').add({
      'title': palette.title,
      'subTitle': palette.subTitle,
      'gradientColors':
          palette.gradientColors.map((color) => color.value).toList(),
      'circleBorderColor': palette.circleBorderColor.value,
      'circleFillColor': palette.circleFillColor.value,
      'price': palette.price, 
    });
  }

  debugPrint("Dummy market verileri Firebase'e yüklendi.");
}
