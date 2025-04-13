import 'package:flutter/material.dart';
import 'main.dart'; // Add this import

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  final TextEditingController _tahunController = TextEditingController();
  String _resultText = '';

  // Results
  int _totalDays = 0;
  int _totalHours = 0;
  int _totalMinutes = 0;
  int _totalSeconds = 0;

  void _convertTime() {
    setState(() {
      try {
        // Parse input
        double tahun = double.parse(_tahunController.text);

        // Convert years to days (approximation)
        _totalDays =
            (tahun * 365.25).round(); // Including leap years approximation

        // Convert to hours, minutes, seconds
        _totalHours = (tahun * 365.25 * 24).round();
        _totalMinutes = (tahun * 365.25 * 24 * 60).round();
        _totalSeconds = (tahun * 365.25 * 24 * 60 * 60).round();

        // Format result text
        _resultText = '$tahun years equals:';
      } catch (e) {
        _resultText = 'Invalid input. Please enter a valid number.';
        _totalDays = 0;
        _totalHours = 0;
        _totalMinutes = 0;
        _totalSeconds = 0;
      }
    });
  }

  @override
  void dispose() {
    _tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Converter')),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                color: AppTheme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Convert Years to Other Units',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _tahunController,
                        decoration: InputDecoration(
                          labelText: 'Years',
                          labelStyle: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: AppTheme.secondaryColor,
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor,
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _convertTime,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            foregroundColor: AppTheme.scaffoldBackgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Convert',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_resultText.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5,
                      color: AppTheme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _resultText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.5,
                                  children: [
                                    _buildResultCard(
                                      'Days',
                                      _totalDays.toString(),
                                      Icons.calendar_month,
                                      AppTheme.secondaryColor,
                                    ),
                                    _buildResultCard(
                                      'Hours',
                                      _totalHours.toString(),
                                      Icons.access_time_filled,
                                      const Color(0xFF5C6BC0),
                                    ),
                                    _buildResultCard(
                                      'Minutes',
                                      _totalMinutes.toString(),
                                      Icons.timer,
                                      const Color(0xFF66BB6A),
                                    ),
                                    _buildResultCard(
                                      'Seconds',
                                      _totalSeconds.toString(),
                                      Icons.timer_10,
                                      const Color(0xFFFF7043),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
