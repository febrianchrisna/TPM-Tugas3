import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'MainMenu.dart';

// Define app theme constants
class AppTheme {
  // Primary color - dark teal
  static const Color primaryColor = Color(0xFF1A434E);

  // Light variant of primary color
  static const Color primaryLightColor = Color(0xFF2C6373);

  // Secondary/accent color - golden amber
  static const Color secondaryColor = Color(0xFFF0B64D);

  // Background color - deeper teal
  static const Color scaffoldBackgroundColor = Color(0xFF0C2126);

  // Card background color
  static const Color cardColor = Color(0xFF143039);

  // Surface color for other elements
  static const Color surfaceColor = Color(0xFF1D4752);

  // Error color
  static const Color errorColor = Color(0xFFCF6679);

  // Text colors
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFB4C9CF);

  // Theme data (if needed elsewhere)
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        labelStyle: const TextStyle(color: textSecondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryLightColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        prefixIconColor: textSecondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Color(0xFF0C2126), // Dark text on light buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: secondaryColor),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPM Tugas 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
        colorScheme: ColorScheme.dark(
          primary: AppTheme.primaryLightColor,
          secondary: AppTheme.secondaryColor,
          surface: AppTheme.surfaceColor,
        ),
        cardColor: AppTheme.cardColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: Color(0xFF0C2126), // Dark text on light buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
          hintStyle: const TextStyle(color: Colors.white60),
        ),
        useMaterial3: true,
      ),
      home: const AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  bool isLoading = true;
  bool isLoggedIn = false;
  String username = 'User';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final savedUsername = prefs.getString('username') ?? 'User';

    setState(() {
      isLoggedIn = isUserLoggedIn;
      username = savedUsername;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isLoggedIn) {
      return MainMenuPage(username: username);
    } else {
      return const LoginPage();
    }
  }
}
