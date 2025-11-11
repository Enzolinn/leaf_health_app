import 'dart:convert'; // Para jsonDecode
import 'dart:io';       // Para a classe File
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Para MediaType
import 'prediction_model.dart'; // Nosso modelo de dados

class ApiService {
  // ATENÇÃO: Lembre-se que URLs do ngrok mudam toda vez
  // que você reinicia o ngrok. Verifique se esta URL está correta.
  final String _apiUrl = "https://obsolete-corie-santalaceous.ngrok-free.dev/predict";

  Future<PredictionResponse> predict(File imageFile) async {
    var uri = Uri.parse(_apiUrl);
    var request = http.MultipartRequest('POST', uri);

    // Adicionando o arquivo
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // O nome do campo que sua API espera
        imageFile.path,
        // Informar o tipo de conteúdo é uma boa prática
        contentType: MediaType('image', 'jpeg'), // ou 'png', etc.
      ),
    );

    // Adicionando headers
    request.headers['Accept'] = 'application/json';

    // Envio da requisição
    var streamed = await request.send();
    var response = await http.Response.fromStream(streamed);

    // Verificação da resposta
    if (response.statusCode == 200) {
      // Se deu certo (200 OK):
      // 1. Decodifica o JSON
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      // 2. Converte o JSON em nosso objeto PredictionResponse
      return PredictionResponse.fromJson(jsonBody);
    } else {
      // Se deu erro:
      throw Exception('Server error: ${response.statusCode} ${response.body}');
    }
  }
}