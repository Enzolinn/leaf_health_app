import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_provider.dart'; // Nosso gerenciador de estado
import 'home_page.dart';           // Nossa tela principal

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
    return MaterialApp(
      title: 'Leaf Health Detector',
      theme: ThemeData(
        // 2. Definimos um tema. O 'primarySwatch' gera várias
        // tonalidades de verde automaticamente.
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 3. Remove o banner "DEBUG" do canto da tela
      debugShowCheckedModeBanner: false,
      // 4. Define a tela inicial do aplicativo
      home: const HomePage(),
    );
  }
}