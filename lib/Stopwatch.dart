import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart'; // Add this import

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _result = '00:00:00.000';
  List<String> _laps = [];
  bool _isProcessing = false; // Prevent rapid button clicks

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  // Helper method to safely cancel timer
  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _start() {
    // Prevent rapid clicking issues
    if (_isProcessing) return;
    _isProcessing = true;

    // Ensure any existing timer is canceled
    _cancelTimer();

    // Force Stopwatch to start
    _stopwatch.start();
    _updateTimerDisplay();

    // Create a new timer
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      _updateTimerDisplay();
    });

    // Reset processing flag after short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _updateTimerDisplay() {
    if (mounted) {
      setState(() {
        _result = _formatTime(_stopwatch.elapsedMilliseconds);
      });
    }
  }

  void _stop() {
    // Prevent rapid clicking issues
    if (_isProcessing) return;
    _isProcessing = true;

    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _cancelTimer();
    }

    // Reset processing flag after short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _reset() {
    _stop();

    // Wait for stop to complete
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _stopwatch.reset();
          _result = '00:00:00.000';
          _laps = [];
          _isProcessing = false;
        });
      }
    });
  }

  void _lap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.insert(0, _result);
      });
    }
  }

  String _formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    var millis = (milliseconds % 1000).toString().padLeft(3, '0');
    return "$hours:$minutes:$seconds.$millis";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _result.substring(0, 8), // HH:MM:SS
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _result.substring(8), // .milliseconds
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.deepOrange[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          label: _stopwatch.isRunning ? 'Stop' : 'Start',
                          color:
                              _stopwatch.isRunning
                                  ? const Color(0xFFCF6679) // Error color
                                  : const Color(0xFF4CAF50), // Green
                          onPressed: _stopwatch.isRunning ? _stop : _start,
                        ),
                        const SizedBox(width: 20),
                        _buildButton(
                          label: 'Reset',
                          color: AppTheme.secondaryColor,
                          onPressed: _reset,
                        ),
                        const SizedBox(width: 20),
                        _buildButton(
                          label: 'Lap',
                          color: AppTheme.primaryLightColor,
                          onPressed: _lap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Laps',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child:
                          _laps.isEmpty
                              ? const Center(
                                child: Text(
                                  'No laps recorded',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                              : ListView.builder(
                                itemCount: _laps.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          AppTheme.primaryLightColor,
                                      child: Text(
                                        '${_laps.length - index}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _laps[index],
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
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

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label),
    );
  }
}
