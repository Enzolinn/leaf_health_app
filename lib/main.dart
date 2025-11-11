import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_provider.dart';
import 'splash_screen.dart';

void main() {
  runApp(
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
      title: 'LeafHealth',
      theme: ThemeData(
        colorSchemeSeed: Colors.green, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,

      home: const SplashScreen(),
    );
  }
}