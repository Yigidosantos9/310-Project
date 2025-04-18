import 'package:flutter/material.dart';
import 'package:spacy_notes/widgets/market_widgets/cut_corner_color_card.dart';
import 'package:spacy_notes/widgets/market_widgets/planet_card_widget.dart';
import 'package:spacy_notes/widgets/market_widgets/profile_picture_card.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int coinAmount = 42;

  // Güncellenmiş gezegen listesi: her biri başlık, alt başlık, resim yolu ve fiyat içeriyor
  final List<Map<String, String>> planets = [
    {
      "title": "Mercury",
      "subTitle": "Closest to the Sun",
      "imagePath": "assets/images/logo.png",
      "price": "150",
    },
    {
      "title": "Venus",
      "subTitle": "The Morning Star",
      "imagePath": "assets/images/logo.png",
      "price": "200",
    },
    {
      "title": "Earth",
      "subTitle": "Blue Planet",
      "imagePath": "assets/images/logo.png",
      "price": "250",
    },
    {
      "title": "Mars",
      "subTitle": "Red Planet",
      "imagePath": "assets/images/logo.png",
      "price": "300",
    },
    {
      "title": "Jupiter",
      "subTitle": "Gas Giant",
      "imagePath": "assets/images/logo.png",
      "price": "350",
    },
    {
      "title": "Saturn",
      "subTitle": "Ringed Beauty",
      "imagePath": "assets/images/logo.png",
      "price": "400",
    },
  ];

  // Profil listesi
  final List<String> profiles = ["Alice", "Bob", "Charlie", "Dave"];

  // Eskiden kullanılan colorPalettes listesi yerine, yeni kartların parametrelerini içeren liste:
  final List<Map<String, dynamic>> paletteCards = [
    {
      "title": "Dusk Horizon",
      "subTitle": "Prismatic",
      "gradientColors": [const Color(0xFF3E2723), const Color(0xFF1B1B1B)],
      "circleBorderColor": Colors.orange,
      "circleFillColor": Colors.orange,
    },
    {
      "title": "Neon Rider",
      "subTitle": "Prismatic",
      "gradientColors": [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
      "circleBorderColor": Colors.orangeAccent,
      "circleFillColor": Colors.orangeAccent,
    },
    {
      "title": "Neon Rider",
      "subTitle": "Prismatic",
      "gradientColors": [
        const Color.fromARGB(255, 87, 194, 180),
        const Color.fromARGB(255, 27, 105, 125),
      ],
      "circleBorderColor": Colors.orangeAccent,
      "circleFillColor": Colors.orangeAccent,
    },
    {
      "title": "Neon Rider",
      "subTitle": "Prismatic",
      "gradientColors": [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
      "circleBorderColor": Colors.orangeAccent,
      "circleFillColor": Colors.orangeAccent,
    },
    {
      "title": "Neon Rider",
      "subTitle": "Prismatic",
      "gradientColors": [const Color(0xFF7E57C2), const Color(0xFF4527A0)],
      "circleBorderColor": Colors.orangeAccent,
      "circleFillColor": Colors.orangeAccent,
    },
  ];

  // Ek placeholder elemanlar
  final List<String> moreItems = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B36),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 1, 37),
        leading: const CloseButton(),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                // 'Spacy ' kısmı gradient ile
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
                // 'Store' kısmı da gradient veya beyaz olarak
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 232, 229, 233),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
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
                Text(
                  '$coinAmount',
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
            // 1. Bölüm: Planets
            const Text(
              "Planets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: planets.length,
                itemBuilder: (context, index) {
                  final planet = planets[index];
                  return PlanetCard(
                    title: planet["title"]!,
                    subTitle: planet["subTitle"]!,
                    imagePath: planet["imagePath"]!,
                    price: planet["price"]!,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // 2. Bölüm: Profile Pictures
            const Text(
              "Profile Pictures",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  return ProfilePictureCard(
                    title: "Winter Serenity",
                    imagePath: "assets/images/logo.png", // or a URL
                    price: "500",
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // 3. Bölüm: Color Palettes (Eskiden kullanılan ColorPaletteCard yerine artık CutCornerColorCard kullanılıyor)
            const Text(
              "Color Palettes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: paletteCards.length,
                itemBuilder: (context, index) {
                  final palette = paletteCards[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CutCornerColorCard(
                      title: palette["title"],
                      subTitle: palette["subTitle"],
                      gradientColors: palette["gradientColors"],
                      circleBorderColor: palette["circleBorderColor"],
                      circleFillColor: palette["circleFillColor"],
                      onInfoPressed: () {
                        // Info ikonuna tıklandığında yapılacak aksiyon
                        debugPrint("${palette["title"]} info tapped!");
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // 4. Bölüm: More Items (Placeholder)
            const Text(
              "More Items",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moreItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Gelecekte aksiyon eklenecek
                    },
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

