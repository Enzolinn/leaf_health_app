import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageDisplay extends StatelessWidget {
  final String base64String;

  const Base64ImageDisplay({Key? key, required this.base64String}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Tenta decodificar a string Base64
    try {
      final String cleanBase64 = base64String.contains(',')
          ? base64String.split(',')[1]
          : base64String;

      // 2. Converte a string limpa em bytes
      final Uint8List imageBytes = base64Decode(cleanBase64);

      // 3. Exibe os bytes como uma imagem
      return Image.memory(
        imageBytes,
        width: 300,
        height: 300,
        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('Erro ao carregar imagem');
        },
      );
    } catch (e) {

      return _buildErrorWidget('Formato Base64 inválido');
    }
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}