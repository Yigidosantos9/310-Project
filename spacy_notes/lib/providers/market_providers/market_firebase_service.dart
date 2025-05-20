// lib/providers/market_providers/market_firestore_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacy_notes/providers/market_providers/market_models.dart';

final firebasePlanetsProvider = FutureProvider<List<Planet>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('market/planets/items')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return Planet(
      title: data['title'],
      subTitle: data['subTitle'],
      imagePath: data['imagePath'],
      price: data['price'].toString(),
    );
  }).toList();
});

final firebaseProfilesProvider = FutureProvider<List<ProfilePicture>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('market/profiles/items')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return ProfilePicture(
      title: data['title'],
      imagePath: data['imagePath'],
      price: data['price'].toString(),
    );
  }).toList();
});

final firebasePalettesProvider = FutureProvider<List<ColorPalette>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('market/palettes/items')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return ColorPalette(
      title: data['title'],
      subTitle: data['subTitle'],
      gradientColors: List<int>.from(data['gradientColors'] ?? [])
          .map((hex) => Color(hex))
          .toList(),
      circleBorderColor: Color(data['circleBorderColor']),
      circleFillColor: Color(data['circleFillColor']),
      price: 300,
    );
  }).toList();
});


enum ItemType { Palette, Profile, Planet }

extension on ItemType {
  String get listField {
    switch (this) {
      case ItemType.Palette: return 'purchasedPalettes';
      case ItemType.Profile: return 'purchasedProfiles';
      case ItemType.Planet:  return 'purchasedPlanets';
    }
  }
}

Future<void> purchaseItem({
  required String userId,
  required ItemType itemType,
  required String itemId,
  required int price,
}) {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  return FirebaseFirestore.instance.runTransaction((tx) async {
    final snap = await tx.get(userRef);
    if (!snap.exists) throw Exception("User does not exist");
    final data = snap.data()!;
    final currentBalance = (data['balance'] as int?) ?? 0;

    if (currentBalance < price) {
      throw Exception("Insufficient balance");
    }

    // Deduct balance and arrayUnion the itemId
    tx.update(userRef, {
      'balance': currentBalance - price,
      itemType.listField: FieldValue.arrayUnion([itemId]),
    });
  });
}
