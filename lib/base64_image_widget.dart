import 'dart:convert'; // Para base64Decode
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/material.dart';

class Base64ImageDisplay extends StatelessWidget {
  final String base64String;

  const Base64ImageDisplay({Key? key, required this.base64String}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Tenta decodificar a string Base64
    try {
      // Algumas APIs incluem um prefixo 'data:image/png;base64,'
      // Este código verifica se o prefixo existe e o remove.
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
        // 4. (Importante) Tratamento de erro caso os bytes
        // não formem uma imagem válida.
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('Erro ao carregar imagem');
        },
      );
    } catch (e) {
      // 5. (Importante) Tratamento de erro caso a string
      // Base64 seja mal formatada.
      return _buildErrorWidget('Formato Base64 inválido');
    }
  }

  // Widget auxiliar para mostrar um erro padronizado
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