import 'dart:io'; // Para a classe File
import 'package:flutter/material.dart'; // Para ChangeNotifier
import 'package:image_picker/image_picker.dart'; // Para pegar imagens
import 'api_service.dart'; // Nosso serviço de API
import 'prediction_model.dart'; // Nosso modelo de dados

class PredictionProvider extends ChangeNotifier {
  // Instâncias privadas dos nossos serviços
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  // --- Variáveis de Estado ---
  // O '_' torna a variável "privada" (só acessível dentro desta classe)

  // Armazena o arquivo da imagem selecionada
  File? _selectedImage;
  // Armazena a resposta da API após a predição
  PredictionResponse? _predictionResponse;
  // Controla se estamos no meio de uma requisição (para mostrar um loading)
  bool _isLoading = false;

  // --- Getters Públicos ---
  // A UI (HomePage) usará estes "getters" para ler o estado.
  File? get selectedImage => _selectedImage;
  PredictionResponse? get predictionResponse => _predictionResponse;
  bool get isLoading => _isLoading;

  // --- Ações (Métodos) ---
  // A UI chamará estas funções para executar ações.

  // Ação para escolher uma imagem (da câmera ou galeria)
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      _predictionResponse = null; // Limpa a predição anterior
      notifyListeners(); // Avisa a UI que a imagem mudou
    }
  }

  // Ação para fazer o upload e receber a predição
  Future<void> uploadAndPredict() async {
    if (_selectedImage == null) return; // Não faz nada se não há imagem

    _isLoading = true;
    notifyListeners(); // Avisa a UI para mostrar o loading

    try {
      // Chama a API com a imagem selecionada
      _predictionResponse = await _apiService.predict(_selectedImage!);
    } catch (e) {
      // Em um app real, você trataria esse erro melhor (ex: mostrar um pop-up)
      print("Erro ao tentar prever: $e");
      _predictionResponse = null;
    }

    _isLoading = false;
    notifyListeners(); // Avisa a UI que o loading terminou (com sucesso ou erro)
  }
}