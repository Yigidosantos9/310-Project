import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/providers/market_providers/dummy_market_service.dart';
import 'package:spacy_notes/providers/market_providers/market_models.dart';

final marketDataProvider = Provider<MarketDataService>((ref) {
  return DummyMarketService();
});


final planetsProvider = FutureProvider<List<Planet>>((ref) {
  final service = ref.read(marketDataProvider);
  return service.fetchPlanets();
});

final profilesProvider = FutureProvider<List<ProfilePicture>>((ref) {
  final service = ref.read(marketDataProvider);
  return service.fetchProfiles();
});

final palettesProvider = FutureProvider<List<ColorPalette>>((ref) {
  final service = ref.read(marketDataProvider);
  return service.fetchPalettes();
});