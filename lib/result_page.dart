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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Resultado da Análise:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
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
                                text: 'Planta inferida: ',
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
                                text: 'Doença inferida: ',
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
                SizedBox(height: 20),
                Text(
                  "Imagem original:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    selectedImage,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Mascara folha saudável:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Base64ImageDisplay(base64String: base64String),
                SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
