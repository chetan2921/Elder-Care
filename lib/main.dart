import 'package:elder_care_assistance/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/home_screen.dart';
import 'services/service_locator.dart';

// Define custom colors
class AppColors {
  static const primaryDark = Color(0xFF1A1A2E);
  static const surfaceDark = Color(0xFF242438);
  static const accentDark = Color(0xFF4B7BF5);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(ElderCareApp());

  final aiService = AIService();
  try {
    await aiService.setApiKey('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');
  } catch (e) {
    print('Error setting API key: $e');
  }
}

class ElderCareApp extends StatelessWidget {
  const ElderCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elder Care Assistant',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.primaryDark,
        primaryColor: AppColors.accentDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentDark,
          secondary: AppColors.accentDark,
          surface: AppColors.surfaceDark,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.textPrimary,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.surfaceDark,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentDark,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentDark,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          // Display
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          // Headline
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          // Title
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          // Body
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.5,
          ),
          // Label
          labelLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.surfaceDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accentDark),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.surfaceDark,
          thickness: 1,
        ),
      ),
      home: HomeScreen(),
    );
  }
}