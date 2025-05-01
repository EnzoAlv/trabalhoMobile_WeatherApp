// Arquivo: lib/services/weather_service.dart (ou onde seu serviço estiver)

import 'dart:convert'; // Para jsonDecode
import 'package:http/http.dart' as http; // Importe o pacote http
import '../models/weather_model.dart'; // Importe seu modelo

class WeatherService {
  // Sua API Key da OpenWeatherMap
  static const String _apiKey = '11794622b0c740d260cd48741cb89bc1';
  // URL base da API OpenWeatherMap para tempo atual
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> getWeatherByCity(String city) async {
    // Monta a URL completa com os parâmetros necessários
    // q = nome da cidade
    // appid = sua chave de API
    // units = metric (para Celsius e m/s)
    // lang = pt_br (para descrições em português, se disponíveis)
    final Uri uri =
        Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=pt_br');

    try {
      // Faz a requisição GET
      final response = await http.get(uri);

      // Verifica se a requisição foi bem-sucedida (código 200)
      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        // Converte o JSON para o nosso objeto WeatherData usando o factory constructor
        return WeatherData.fromJson(jsonResponse);
      } else {
        // Se o status não for 200, lança um erro com a mensagem da API ou um padrão
        String errorMessage = 'Falha ao carregar dados do clima.';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage = errorJson['message'] ??
              errorMessage; // Tenta pegar a mensagem de erro da API
        } catch (e) {
          // Ignora erro de parsing do corpo do erro, mantém mensagem padrão
        }
        print(
            'Erro API: ${response.statusCode} - ${response.body}'); // Log para depuração
        throw Exception('$errorMessage (Código: ${response.statusCode})');
      }
    } catch (e) {
      // Captura erros de rede ou outros erros durante a requisição/processamento
      print('Erro ao buscar clima: $e'); // Log para depuração
      throw Exception(
          'Não foi possível conectar ao serviço de clima. Verifique sua conexão.');
    }
  }
}
