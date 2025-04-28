📱 Weather App Flutter - Previsão do Tempo
Aplicativo simples de clima usando Flutter + API Meteoblue.
Permite buscar o clima atual de qualquer cidade digitando o nome (ex: São Paulo, Brasil) e exibe temperatura e ícone correspondente.

🚀 Tecnologias Utilizadas
Flutter (SDK >= 3.x)

Dart (linguagem)

HTTP (requisições)

Meteoblue API (clima)

OpenStreetMap Nominatim (geolocalização)

📦 Dependências do Projeto
Certifique-se de instalar as seguintes dependências no seu projeto Flutter:

bash
Copiar
Editar
flutter pub add http
flutter pub add shared_preferences
flutter pub add crypto
Ou diretamente no pubspec.yaml:

yaml
Copiar
Editar
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.0
  crypto: ^3.0.3
Depois, atualize com:

bash
Copiar
Editar
flutter pub get
⚙️ Como configurar
Chave da API Meteoblue

Crie uma conta gratuita em Meteoblue API

Gere uma API Key e o Shared Secret

No arquivo /lib/services/meteoblue_service.dart, substitua:

dart
Copiar
Editar
static const String _sharedSecret = 'SUA_SHARED_SECRET';
static const String _apiKey = 'SUA_API_KEY';
Permissões Android

Adicione no AndroidManifest.xml:

xml
Copiar
Editar
<uses-permission android:name="android.permission.INTERNET" />
🛠 Estrutura de Pastas
bash
Copiar
Editar
lib/
├── pages/
│   └── home_screen.dart      # Tela principal
├── services/
│   ├── meteoblue_service.dart # Serviço de consumo da API Meteoblue
│   └── storage_service.dart   # Armazena cidade no dispositivo (SharedPreferences)
└── main.dart                  # Ponto de entrada do app
📋 Funcionalidades
🌍 Buscar clima de qualquer cidade digitando "Cidade, País"

☀️ Ícones para diferentes condições meteorológicas

💾 Armazenamento local da cidade para reabrir o app sem precisar digitar novamente

🔄 Botão para trocar a cidade a qualquer momento

🎯 Erro amigável quando cidade não encontrada ou API indisponível

🧪 Como rodar o projeto
Clone o repositório:

bash
Copiar
Editar
git clone https://github.com/seu-usuario/weather-flutter-app.git
Acesse a pasta:

bash
Copiar
Editar
cd weather-flutter-app
Instale dependências:

bash
Copiar
Editar
flutter pub get
Execute o app:

bash
Copiar
Editar
flutter run
🔥 Melhorias Futuras
Forecast de vários dias





📜 Licença
Este projeto está licenciado sob a licença MIT.
Sinta-se livre para usar, melhorar e contribuir!

💬 Contato
Desenvolvido por Enzo Alvarenga].
📧 Email: alvarengaenzo2005@gmail.com
