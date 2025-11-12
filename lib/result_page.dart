import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leaf_health_app/base64_image_widget.dart';

class ResultPage extends StatelessWidget {
  final String base64String;
  final File selectedImage;
  final String planta;
  final String doenca;
  const ResultPage({
    super.key,
    required this.base64String,
    required this.selectedImage,
    required this.doenca,
    required this.planta,
  });

  @override
  Widget build(BuildContext contex) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Resultado da Análise:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          CarouselView(
            itemExtent: double.infinity,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  selectedImage,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Base64ImageDisplay(base64String: base64String),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 18),
                      children: [
                        const TextSpan(
                          text: 'Planta: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: planta),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 18),
                      children: [
                        const TextSpan(
                          text: 'Doença: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: doenca,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
