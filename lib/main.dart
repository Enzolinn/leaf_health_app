import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_provider.dart'; // Nosso gerenciador de estado
import 'home_page.dart'; // Nossa tela principal

void main() {
  runApp(
    // 1. Envolvemos o app todo no Provider.
    // Isso permite que qualquer widget "descendente" acesse o PredictionProvider.
    ChangeNotifierProvider(
      create: (context) => PredictionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primarySeedColor = Color(0xFF2F9E44);
    return MaterialApp(
      title: 'Leaf Health Detector',
      theme: ThemeData(
        // 2. Definimos um tema. O 'primarySwatch' gera várias
        // tonalidades de verde automaticamente.
        colorScheme: ColorScheme.fromSeed(
          seedColor: primarySeedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F3),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1B4332),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 3. Remove o banner "DEBUG" do canto da tela
      debugShowCheckedModeBanner: false,
      // 4. Define a tela inicial do aplicativo
      home: const HomePage(),
    );
  }
}
