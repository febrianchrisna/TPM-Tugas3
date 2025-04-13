import 'package:flutter/material.dart';
import 'main.dart'; // Add this import

class BilanganPage extends StatefulWidget {
  const BilanganPage({super.key});

  @override
  State<BilanganPage> createState() => _BilanganPageState();
}

class _BilanganPageState extends State<BilanganPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _isPrime = false;
  bool _isInteger = false;
  bool _isPositive = false;
  bool _isNatural = false;
  bool _isDecimal = false;

  void _checkNumber() {
    setState(() {
      try {
        String input = _controller.text;

        // Check if it's a decimal number
        if (input.contains('.')) {
          double number = double.parse(input);
          _isDecimal = true;
          _isInteger = false;
          _isPositive = number > 0;
          _isNatural = false; // Natural numbers are positive integers
          _isPrime = false; // Prime numbers are integers
          _result = '$number is a decimal number';
        } else {
          int number = int.parse(input);
          _isDecimal = false;
          _isInteger = true;
          _isPositive = number > 0;
          _isNatural = number > 0; // Natural numbers are positive integers

          // Check if prime
          _isPrime = isPrime(number);

          _result =
              '$number is ' +
              (_isPrime ? 'a prime number' : 'not a prime number');
        }
      } catch (e) {
        _result = 'Invalid input. Please enter a number.';
        _isPrime = false;
        _isInteger = false;
        _isPositive = false;
        _isNatural = false;
        _isDecimal = false;
      }
    });
  }

  bool isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;

    int i = 5;
    while (i * i <= n) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
      i += 6;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Types')),
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
                    children: [
                      const Text(
                        'Enter a number to check its type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Number',
                          labelStyle: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.calculate_rounded,
                            color: AppTheme.secondaryColor,
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor,
                          // Removing any hashtag-related styling
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _checkNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: AppTheme.scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Check'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_result.isNotEmpty)
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
                        Text(
                          _result,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTypeItem(
                          'Prime Number',
                          _isPrime,
                          AppTheme.secondaryColor,
                        ),
                        _buildTypeItem(
                          'Integer',
                          _isInteger,
                          const Color(0xFF5C6BC0),
                        ),
                        _buildTypeItem(
                          'Positive Number',
                          _isPositive,
                          const Color(0xFF66BB6A),
                        ),
                        _buildTypeItem(
                          'Natural Number',
                          _isNatural,
                          const Color(0xFFFF7043),
                        ),
                        _buildTypeItem(
                          'Decimal Number',
                          _isDecimal,
                          const Color(0xFF26A69A),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeItem(String title, bool isTrue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isTrue ? color : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isTrue ? Icons.check : Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isTrue ? color : Colors.grey,
              fontWeight: isTrue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
