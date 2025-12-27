import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. EKLENDİ: Firebase çekirdek paketi
import 'firebase_options.dart'; // 2. EKLENDİ: Az önce oluşturduğumuz ayar dosyası

import 'features/auth/splash_screen.dart';
import 'core/theme/app_theme.dart';

// 3. DEĞİŞTİ: main fonksiyonu 'async' yapıldı (bekleme yapabilmesi için)
void main() async {
  // 4. EKLENDİ: Flutter motorunu hazırlar (Firebase başlamadan önce şarttır)
  WidgetsFlutterBinding.ensureInitialized();

  // 5. EKLENDİ: Firebase'i başlatma emri
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EderiNeApp());
}

class EderiNeApp extends StatelessWidget {
  const EderiNeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ederi Ne?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.navyDark,
          primary: AppTheme.navyDark,
          secondary: AppTheme.accentGold,
          surface: AppTheme.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.textWhite,
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppTheme.accentGold, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppTheme.navyDark, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          hintStyle: TextStyle(color: AppTheme.textGrey),
          prefixIconColor: AppTheme.accentGold,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGold,
            foregroundColor: AppTheme.navyDark,
            elevation: 5,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}