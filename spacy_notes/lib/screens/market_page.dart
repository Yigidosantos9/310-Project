import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/providers/market_providers/market_firebase_service.dart';
import 'package:spacy_notes/providers/user_provider.dart';
import 'package:spacy_notes/widgets/market_widgets/cut_corner_color_card.dart';
import 'package:spacy_notes/widgets/market_widgets/item_purchase.dart';
import 'package:spacy_notes/widgets/market_widgets/planet_card_widget.dart';
import 'package:spacy_notes/widgets/market_widgets/profile_picture_card.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage> {
  void showPurchaseDialog({
    required String userId,
    required ItemType itemType,
    required String itemId,
    required String itemName,
    required int itemPrice,
  }) {
    final userBalance = ref.read(userProvider)?.balance ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return PurchaseDialog(
          itemName: itemName,
          itemPrice: itemPrice,
          userBalance: userBalance,
          onBuy: () async {
            try {
              await purchaseItem(
                userId: userId,
                itemType: itemType,
                itemId: itemId,
                price: itemPrice,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Purchase successful! 🚀')),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: \$e')));
            }
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final planetsAsync = ref.watch(firebasePlanetsProvider);
    final profilesAsync = ref.watch(firebaseProfilesProvider);
    final palettesAsync = ref.watch(firebasePalettesProvider);
    final user = ref.watch(userProvider);
    final balance = user?.balance ?? 0;
    final userId = user?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF060B36),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 1, 37),
        leading: const CloseButton(),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [Color(0xFF5B2C6F), Color(0xFF9B59B6)],
                        ).createShader(bounds),
                    child: const Text(
                      'Spacy ',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [Color(0xFFE8E5E9), Color(0xFFFFFFFF)],
                        ).createShader(bounds),
                    child: const Text(
                      'Store',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Image.asset('images/currency.png', width: 24, height: 24),
                const SizedBox(width: 4),
                Text(
                  '$balance',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Planets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            planetsAsync.when(
              data:
                  (planets) => SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: planets.length,
                      itemBuilder: (context, index) {
                        final p = planets[index];
                        return GestureDetector(
                          onTap: () {
                            if (userId != null) {
                              showPurchaseDialog(
                                userId: userId,
                                itemType: ItemType.Planet,
                                itemId: p.title,
                                itemName: p.title,
                                itemPrice: int.tryParse(p.price) ?? 0,
                              );
                            }
                          },
                          child: PlanetCard(
                            title: p.title,
                            subTitle: p.subTitle,
                            imagePath: p.imagePath,
                            price: p.price,
                          ),
                        );
                      },
                    ),
                  ),
              loading: () => const CircularProgressIndicator(),
              error:
                  (e, _) => Text(
                    'Error: \$e',
                    style: const TextStyle(color: Colors.red),
                  ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Profile Pictures",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            profilesAsync.when(
              data:
                  (profiles) => SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return GestureDetector(
                          onTap: () {
                            if (userId != null) {
                              showPurchaseDialog(
                                userId: userId,
                                itemType: ItemType.Profile,
                                itemId: profile.title,
                                itemName: profile.title,
                                itemPrice: int.tryParse(profile.price) ?? 0,
                              );
                            }
                          },
                          child: ProfilePictureCard(
                            title: profile.title,
                            imagePath: profile.imagePath,
                            price: profile.price,
                          ),
                        );
                      },
                    ),
                  ),
              loading: () => const CircularProgressIndicator(),
              error:
                  (e, _) => Text(
                    'Error: \$e',
                    style: const TextStyle(color: Colors.red),
                  ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Color Palettes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            palettesAsync.when(
              data:
                  (palettes) => SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: palettes.length,
                      itemBuilder: (context, index) {
                        final palette = palettes[index];
                        return GestureDetector(
                          onTap: () {
                            if (userId != null) {
                              showPurchaseDialog(
                                userId: userId,
                                itemType: ItemType.Palette,
                                itemId: palette.title,
                                itemName: palette.title,
                                itemPrice: palette.price,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: CutCornerColorCard(
                              title: palette.title,
                              subTitle: palette.subTitle,
                              gradientColors: palette.gradientColors,
                              circleBorderColor: palette.circleBorderColor,
                              circleFillColor: palette.circleFillColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              loading: () => const CircularProgressIndicator(),
              error:
                  (e, _) => Text(
                    'Error: \$e',
                    style: const TextStyle(color: Colors.red),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
