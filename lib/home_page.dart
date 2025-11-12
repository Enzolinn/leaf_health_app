import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para ImageSource
import 'package:leaf_health_app/result_page.dart';
import 'package:provider/provider.dart'; // Para context.watch
import 'prediction_provider.dart'; // Nosso provider
import 'prediction_model.dart'; // Nosso modelo (para o tipo da resposta)
import 'base64_image_widget.dart'; // Nosso widget de imagem

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Assiste a mudanças no provider.
    // Qualquer 'notifyListeners()' no provider fará este widget ser reconstruído.
    final provider = context.watch<PredictionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detector de Saúde Foliar'),
      ),
      // 2. SingleChildScrollView evita que o conteúdo
      // "estoure" a tela quando os resultados aparecerem.
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- 3. Área de Exibição da Imagem ---
              GestureDetector(
                // Permite que o usuário clique na imagem para trocá-la
                onTap: () => _showPicker(context),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: provider.selectedImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined, size: 80, color: Colors.grey),
                            Text('Toque para selecionar imagem'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            provider.selectedImage!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // --- 4. Botões de Seleção (só aparecem se não houver imagem) ---
              if (provider.selectedImage == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Câmera'),
                      onPressed: () => provider.pickImage(ImageSource.camera),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeria'),
                      onPressed: () => provider.pickImage(ImageSource.gallery),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // --- 5. Botão de Analisar ---
      
              if (provider.selectedImage != null && !provider.isLoading)
                ElevatedButton.icon(
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Analisar Imagem'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Cor de destaque
                    foregroundColor: Colors.white, // Cor do texto
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => provider.uploadAndPredict(),
                ),

              // --- 6. Indicador de Loading ---
              // Aparece quando 'isLoading' é true
              if (provider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Analisando...'),
                    ],
                  ),
                ),

              // --- 7. Seção de Resultados ---
              // Aparece quando a resposta da API chega E não estamos carregando
              if (provider.predictionResponse != null && !provider.isLoading)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          doenca: provider.predictionResponse!.disease,
                          planta: provider.predictionResponse!.plant,
                          selectedImage: provider.selectedImage!,
                          base64String: provider.predictionResponse!.maskPngB64,
                        ),
                      ),
                    );
                  },
                  child: Text("resultado pronto"),
                )
                
              
          
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Mostra os botões de Câmera/Galeria
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        final provider = context.read<PredictionProvider>();
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  provider.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  provider.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


}