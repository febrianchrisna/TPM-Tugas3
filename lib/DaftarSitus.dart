import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Add this import

class Website {
  final String name;
  final String url;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Website({
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });
}

class DaftarSitusPage extends StatefulWidget {
  const DaftarSitusPage({super.key});

  // Add static method to access websites
  static List<Website> getWebsites() {
    return [
      Website(
        name: 'Codewars',
        url: 'https://www.codewars.com/',
        imageUrl: 'assets/codewars.png',
        description:
            'Platform berbasis komunitas untuk berlatih dan meningkatkan keterampilan coding dengan tantangan berbasis permainan',
      ),
      Website(
        name: 'Coursera',
        url: 'https://www.coursera.org/',
        imageUrl: 'assets/coursera.png',
        description:
            'Coursera adalah platform pembelajaran online menawarkan akses gratis ke banyak kursus tanpa biaya.',
      ),
      Website(
        name: 'Pexels',
        url: 'https://www.pexels.com/',
        imageUrl: 'assets/pexels.png',
        description:
            'Menyediakan gambar dan video bebas hak cipta yang dapat digunakan untuk keperluan desain.',
      ),
      Website(
        name: 'DeepL',
        url: 'https://www.deepl.com/en/translator',
        imageUrl: 'assets/deepl.png',
        description:
            'Layanan penerjemah yang baik dalam hal akurasi dan kualitas terjemahan. DeepL menggunakan teknologi artificial intelligence (AI) dan neural networks untuk menghasilkan terjemahan yang lebih alami',
      ),
      Website(
        name: 'Carousell',
        url: 'https://id.carousell.com/',
        imageUrl: 'assets/carousel.png',
        description:
            'Marketplace yang memungkinkan pengguna untuk menjual dan membeli barang secara langsung melalui aplikasi atau situs web.pembeli dapat langsung menghubungi penjual melalui fitur chat untuk bernegosiasi atau membeli barang tersebut',
      ),
      Website(
        name: 'Habitica',
        url: 'https://habitica.com/static/home',
        imageUrl: 'assets/habitica.png',
        description:
            'Aplikasi pengelolaan tugas yang unik dan menarik karena mengubah rutinitas sehari-hari menjadi permainan',
      ),
    ];
  }

  @override
  State<DaftarSitusPage> createState() => _DaftarSitusPageState();
}

class _DaftarSitusPageState extends State<DaftarSitusPage> {
  late List<Website> websites;

  @override
  void initState() {
    super.initState();
    websites = DaftarSitusPage.getWebsites();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < websites.length; i++) {
        websites[i].isFavorite =
            prefs.getBool('website_favorite_${websites[i].name}') ?? false;
      }
    });
  }

  Future<void> _toggleFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      websites[index].isFavorite = !websites[index].isFavorite;
      prefs.setBool(
        'website_favorite_${websites[index].name}',
        websites[index].isFavorite,
      );
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // If launching fails
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommended Sites')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              Color(0xFF102E40), // Slightly lighter deep blue-teal
              AppTheme.scaffoldBackgroundColor,
            ],
            stops: [0.0, 0.5, 1.0], // Smooth transition points
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: websites.length,
            itemBuilder: (context, index) {
              final website = websites[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 5,
                color: AppTheme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        website.imageUrl,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                website.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  website.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      website.isFavorite
                                          ? Colors.pinkAccent[100]
                                          : Colors.grey,
                                ),
                                onPressed: () => _toggleFavorite(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            website.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _launchURL(website.url),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Visit Website'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
