import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/providers/market_providers/market_data_provider.dart';
import 'package:spacy_notes/widgets/market_widgets/cut_corner_color_card.dart';
import 'package:spacy_notes/widgets/market_widgets/planet_card_widget.dart';
import 'package:spacy_notes/widgets/market_widgets/profile_picture_card.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage> {
  int coinAmount = 42;

  final List<String> moreItems = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
  ];

  @override
  Widget build(BuildContext context) {
    final planetsAsync = ref.watch(planetsProvider);
    final profilesAsync = ref.watch(profilesProvider);
    final palettesAsync = ref.watch(palettesProvider);

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
                    shaderCallback: (bounds) => const LinearGradient(
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
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color.fromARGB(255, 232, 229, 233), Color.fromARGB(255, 255, 255, 255)],
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
                const Icon(Icons.monetization_on, color: Colors.yellowAccent),
                const SizedBox(width: 4),
                Text('$coinAmount', style: const TextStyle(color: Colors.white)),
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
            const Text("Planets", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            planetsAsync.when(
              data: (planets) => SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    final p = planets[index];
                    return PlanetCard(
                      title: p.title,
                      subTitle: p.subTitle,
                      imagePath: p.imagePath,
                      price: p.price,
                    );
                  },
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
            ),

            const SizedBox(height: 24),
            const Text("Profile Pictures", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            profilesAsync.when(
              data: (profiles) => SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return ProfilePictureCard(
                      title: profile.title,
                      imagePath: profile.imagePath,
                      price: profile.price,
                    );
                  },
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
            ),

            const SizedBox(height: 24),
            const Text("Color Palettes", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            palettesAsync.when(
              data: (palettes) => SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: palettes.length,
                  itemBuilder: (context, index) {
                    final palette = palettes[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CutCornerColorCard(
                        title: palette.title,
                        subTitle: palette.subTitle,
                        gradientColors: palette.gradientColors,
                        circleBorderColor: palette.circleBorderColor,
                        circleFillColor: palette.circleFillColor,
                        onInfoPressed: () {
                          debugPrint("${palette.title} info tapped!");
                        },
                      ),
                    );
                  },
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
            ),

            const SizedBox(height: 24),
            const Text("More Items", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moreItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          moreItems[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}