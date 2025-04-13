import 'package:flutter/material.dart';
import 'main.dart'; // Add this import

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HelpItem> helpItems = [
      HelpItem(
        title: 'Stopwatch',
        description:
            'Use the stopwatch to measure elapsed time. Press Start to begin timing, Stop to pause, Reset to clear, and Lap to record split times.',
        icon: Icons.timer,
        color: AppTheme.secondaryColor,
      ),
      HelpItem(
        title: 'Number Types',
        description:
            'Enter any number to identify its type. The app will tell you if it\'s prime, integer, positive, natural, or decimal.',
        icon: Icons.format_list_numbered,
        color: const Color(0xFF26A69A),
      ),
      HelpItem(
        title: 'Location Tracker',
        description:
            'Track your current location and movement history. Enable location services when prompted for accurate results.',
        icon: Icons.location_on,
        color: Colors.redAccent[400]!,
      ),
      HelpItem(
        title: 'Time Converter',
        description:
            'Convert years to days, hours, minutes, and seconds. Enter a value in years and tap Convert to see the results.',
        icon: Icons.access_time,
        color: Colors.purple[300]!,
      ),
      HelpItem(
        title: 'Recommended Sites',
        description:
            'Browse recommended websites for developers. Tap the favorite icon to save sites to your favorites list.',
        icon: Icons.web,
        color: Colors.blue[300]!,
      ),
      HelpItem(
        title: 'Favorites',
        description:
            'View all websites you\'ve marked as favorites. You can remove sites from favorites by tapping the heart icon again.',
        icon: Icons.favorite,
        color: Colors.pinkAccent[100]!,
      ),
    ];

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'App Help',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn how to use the app features',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: helpItems.length,
                itemBuilder: (context, index) {
                  final item = helpItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    color: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Increased border radius
                      side: BorderSide(
                        color: item.color.withOpacity(0.3),
                        width: 1.0,
                      ), // Added subtle border
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Clip contents to match card radius
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item.icon, color: item.color),
                        ),
                        iconColor: Colors.grey[400],
                        collapsedIconColor: Colors.grey[400],
                        backgroundColor: AppTheme.cardColor,
                        collapsedBackgroundColor: AppTheme.cardColor,
                        childrenPadding: const EdgeInsets.all(16),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        collapsedShape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppTheme.surfaceColor.withOpacity(0.3),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
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

class HelpItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  HelpItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
