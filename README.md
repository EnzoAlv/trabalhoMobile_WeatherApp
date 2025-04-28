📱 Weather App Flutter
Aplicativo simples para exibir o clima atual de uma cidade utilizando Flutter, OpenStreetMap e a API da Meteoblue.

🚀 Tecnologias Utilizadas
Flutter (SDK >= 3.x)

Dart (linguagem)

HTTP (requisições HTTP)

Meteoblue API (dados climáticos)

OpenStreetMap Nominatim API (busca de coordenadas)

Shared Preferences (armazenamento local da cidade)

📦 Dependências do Projeto
Instale as dependências necessárias:
flutter pub add http
flutter pub add shared_preferences
flutter pub add crypto

Ou adicione no seu pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.0
  crypto: ^3.0.3

E atualize os pacotes:

flutter pub get
⚙️ Configuração
Configure a API da Meteoblue

Crie uma conta gratuita em Meteoblue Developer Portal.

Gere uma API Key e um Shared Secret.

Substitua as variáveis no arquivo /lib/services/meteoblue_service.dart:

static const String _sharedSecret = 'SUA_SHARED_SECRET';
static const String _apiKey = 'SUA_API_KEY';

Permissões Android

No arquivo android/app/src/main/AndroidManifest.xml, adicione:

<uses-permission android:name="android.permission.INTERNET" />


🛠 Estrutura do Projeto

lib/
├── pages/
│   └── home_screen.dart          # Tela principal do app
├── services/
│   ├── meteoblue_service.dart     # Serviço para consumir a API Meteoblue
│   └── storage_service.dart       # Serviço para armazenar a cidade localmente
└── main.dart                      # Ponto de entrada do aplicativo


📋 Funcionalidades Disponíveis
Digitar uma cidade para buscar o clima atual (exemplo: Lisboa, Portugal).

Exibir a temperatura atual e um ícone representando o clima.

Salvar a cidade digitada localmente para reusar nas próximas vezes.

Possibilidade de alterar a cidade a qualquer momento pelo botão no AppBar.

Mensagens de erro amigáveis caso a cidade não seja encontrada ou o clima esteja indisponível.

🧪 Como Rodar o Projeto
1.Clone o repositório:

git clone https://github.com/seu-usuario/weather-flutter-app.git

2.Acesse o diretório do projeto:

cd weather-flutter-app

3.Instale as dependências:

flutter pub get

4.Execute o aplicativo:

flutter run

