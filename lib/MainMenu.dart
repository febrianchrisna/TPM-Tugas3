import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Stopwatch.dart';
import 'Bilangan.dart';
import 'LBS.dart';
import 'Konversi.dart';
import 'DaftarSitus.dart';
import 'DaftarAnggota.dart';
import 'About.dart';
import 'login_page.dart';
import 'favorites.dart';
import 'main.dart'; // Import for AppTheme

class MainMenuPage extends StatefulWidget {
  final String username;

  const MainMenuPage({super.key, this.username = 'User'});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MainMenuContent(username: widget.username),
      const DaftarAnggotaPage(),
      const AboutPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppTheme.cardColor,
          selectedItemColor: AppTheme.secondaryColor,
          unselectedItemColor: AppTheme.textSecondaryColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: AppTheme.scaffoldBackgroundColor,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}

class MainMenuContent extends StatelessWidget {
  final String username;

  const MainMenuContent({super.key, this.username = 'User'});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add padding between app bar and welcome message
            const SizedBox(height: 30),
            Text(
              'Selamat Datang, $username',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Main Menu',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      'Stopwatch',
                      Icons.timer,
                      Colors.deepOrange[300]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StopwatchPage(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Number Types',
                      Icons.format_list_numbered,
                      Colors.teal[300]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BilanganPage(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Location Tracker',
                      Icons.location_on,
                      Colors.redAccent[400]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LBSPage(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Time Converter',
                      Icons.access_time,
                      Colors.purple[300]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KonversiPage(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Recommended Sites',
                      Icons.web,
                      Colors.blue[300]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaftarSitusPage(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Favorites',
                      Icons.favorite,
                      Colors.pinkAccent[100]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 5,
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
