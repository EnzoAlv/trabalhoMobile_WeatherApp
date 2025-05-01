// Arquivo: lib/models/weather_model.dart (ou onde seu modelo estiver)

class WeatherData {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  // Factory constructor para criar uma instância WeatherData a partir do JSON da OpenWeatherMap
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // Extraindo dados do JSON. Atenção à estrutura aninhada!
    final mainData = json['main'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>?;
    final windData = json['wind'] as Map<String, dynamic>?;

    // Pega o primeiro item da lista 'weather' se existir, senão usa um mapa vazio
    final weatherInfo = weatherList != null && weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    return WeatherData(
      // Nome da cidade
      cityName: json['name'] as String? ?? 'N/A',
      // Temperatura (vem em Kelvin por padrão, convertida para Celsius se 'units=metric')
      temperature: (mainData?['temp'] as num?)?.toDouble() ?? 0.0,
      // Descrição do clima (ex: "nublado", "chuva leve")
      description: (weatherInfo['description'] as String?) ?? 'N/A',
      // Código do ícone (ex: "04d") - pode ser usado para mostrar um ícone correspondente
      iconCode: (weatherInfo['icon'] as String?) ?? '',
      // Umidade em porcentagem
      humidity: (mainData?['humidity'] as num?)?.toInt() ?? 0,
      // Velocidade do vento (vem em m/s por padrão se 'units=metric')
      windSpeed: (windData?['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Método para obter a URL do ícone da OpenWeatherMap (exemplo)
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
