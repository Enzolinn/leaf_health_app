# 🍃 Detector de Saúde Foliar

![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter)

Este é um aplicativo móvel, desenvolvido em Flutter, que utiliza um modelo de *Deep Learning* para identificar doenças em folhas de plantas. O usuário pode tirar uma foto ou escolher uma imagem da galeria, e o app envia para uma API que retorna o diagnóstico.

## 🎥 Vídeo de Funcionamento


## 🛠️ Tecnologias e Pacotes Utilizados

* **Flutter** - Framework principal
* **`provider`** - Para gerenciamento de estado
* **`http`** - Para realizar requisições à API
* **`image_picker`** - Para selecionar imagens da câmera ou galeria

## 🚀 Como Executar o Projeto

Para rodar este projeto localmente, você precisará de duas coisas: o **Backend (a API)** e o **App (este repositório)**.

### 1. Pré-requisitos (Backend)

Este aplicativo *precisa* que o servidor (API) que faz a análise esteja rodando e acessível.

1.  Inicie seu servidor de backend.
2.  Exponha sua API local para a internet. Nós utilizamos o **ngrok** para isso.
    ```bash
    ngrok http 8000
    ```
3.  Copie a URL `https` gerada pelo ngrok.

### 2. Configuração (App)

1.  Clone este repositório:
    ```bash
    git clone [https://github.com/Enzolinn/leaf_health_app.git]
    cd leaf_health_app
    ```

2.  Instale as dependências:
    ```bash
    flutter pub get
    ```

3.  **⚠️ ATUALIZE A URL DA API:**
    Abra o arquivo `lib/api_service.dart` e cole a URL do `ngrok` (do passo 1) na variável `_apiUrl`:

    ```dart
    // lib/api_service.dart
    final String _apiUrl = "[https://SUA-URL-DO-NGROK-AQUI.ngrok-free.dev/predict](https://SUA-URL-DO-NGROK-AQUI.ngrok-free.dev/predict)";
    ```

4.  Execute o aplicativo em um emulador ou dispositivo Android físico:
    ```bash
    flutter run
    ```

## 👤 Autores

* **[Carlos Eduardo Batista, Enzo Zanatta & Eduardo Colet]**
