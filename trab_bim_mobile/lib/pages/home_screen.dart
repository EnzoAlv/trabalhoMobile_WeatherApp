// Arquivo: lib/screens/home_screen.dart (ou onde sua tela principal estiver)

import 'package:flutter/material.dart';
import '../models/weather_service.dart'; // Importe o serviço
import '../models/weather_model.dart'; // Importe o modelo

class HomeScreen extends StatefulWidget {
  // Se você tinha construtores ou parâmetros, mantenha-os
  const HomeScreen({super.key}); // Exemplo

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService =
      WeatherService(); // Instancia o serviço

  WeatherData? _weatherData; // Para armazenar os dados do clima recebidos
  bool _isLoading = false; // Para mostrar indicador de carregamento
  String? _errorMessage; // Para mostrar mensagens de erro

  // Função para buscar o clima
  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, digite o nome da cidade.";
        _weatherData = null; // Limpa dados antigos
      });
      return; // Sai se o campo estiver vazio
    }

    setState(() {
      _isLoading = true; // Inicia o carregamento
      _errorMessage = null; // Limpa erros anteriores
      _weatherData = null; // Limpa dados antigos enquanto carrega novos
    });

    try {
      // Chama o serviço para buscar os dados da cidade digitada
      final weather =
          await _weatherService.getWeatherByCity(_cityController.text);
      setState(() {
        _weatherData = weather; // Armazena os dados recebidos
        _isLoading = false; // Termina o carregamento
      });
    } catch (e) {
      setState(() {
        // Armazena a mensagem de erro vinda da Exception
        _errorMessage = e
            .toString()
            .replaceFirst('Exception: ', ''); // Remove o "Exception: "
        _isLoading = false; // Termina o carregamento
        _weatherData = null; // Garante que não há dados antigos sendo mostrados
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose(); // Limpa o controller ao sair da tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MANTENHA O SEU SCAFFOLD E A ESTRUTURA DA SUA UI AQUI
    // Abaixo está um EXEMPLO de como integrar a busca e exibição

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima App'),
        // Mantenha o resto do seu AppBar (ações do Firebase, etc.)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estica os filhos horizontalmente
          children: [
            // --- Campo de Busca ---
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Digite o nome da cidade',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchWeather, // Chama a busca ao clicar
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) =>
                  _fetchWeather(), // Chama a busca ao pressionar Enter/Done
            ),
            const SizedBox(height: 20),

            // --- Exibição dos Dados ---
            Expanded(
              // Para ocupar o espaço restante
              child: Center(
                // Centraliza o conteúdo
                child: _buildWeatherDisplay(), // Chama o widget de exibição
              ),
            ),

            // MANTENHA OUTROS ELEMENTOS DA SUA UI AQUI (Botões do Firebase, etc.)
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir a exibição do clima
  Widget _buildWeatherDisplay() {
    if (_isLoading) {
      return const CircularProgressIndicator(); // Mostra carregando
    } else if (_errorMessage != null) {
      return Text(
        'Erro: $_errorMessage',
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ); // Mostra erro
    } else if (_weatherData != null) {
      // Mostra os dados do clima - Adapte esta parte ao seu design!
      return Column(
        mainAxisSize:
            MainAxisSize.min, // Encolhe a coluna para o tamanho do conteúdo
        children: [
          Text(
            _weatherData!.cityName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium, // Estilo maior para cidade
          ),
          // Exemplo de exibição do ícone (requer Image.network)
          if (_weatherData!.iconCode.isNotEmpty)
            Image.network(
              _weatherData!.iconUrl, // Usa o getter do modelo
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error_outline,
                  size: 50), // Ícone de erro se falhar ao carregar
            ),
          Text(
            '${_weatherData!.temperature.toStringAsFixed(1)} °C', // Temperatura formatada
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            _weatherData!.description, // Descrição (ex: "céu limpo")
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Espaça igualmente
            children: [
              _buildInfoColumn(Icons.water_drop_outlined, 'Umidade',
                  '${_weatherData!.humidity}%'),
              _buildInfoColumn(Icons.air, 'Vento',
                  '${_weatherData!.windSpeed.toStringAsFixed(1)} m/s'),
            ],
          ),
          // Adicione mais informações aqui se desejar (sensação térmica, pressão, etc.)
          // Lembre-se de adicionar os campos correspondentes no WeatherData e no fromJson
        ],
      );
    } else {
      // Mensagem inicial antes de qualquer busca
      return const Text(
        'Digite uma cidade para ver o clima.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      );
    }
  }

  // Widget auxiliar para criar colunas de informação (umidade, vento, etc.)
  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
