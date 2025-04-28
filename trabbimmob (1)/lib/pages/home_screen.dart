import 'package:flutter/material.dart';
import '../services/meteoblue_service.dart';
import '../services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? city;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    checkCityAndLoadWeather();
  }

  Future<void> checkCityAndLoadWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    city = await StorageService.getCity();
    if (city == null) {
      await askForCity();
    }
    await fetchCoordinatesAndWeather(city!);
  }

  Future<void> askForCity() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Informe sua cidade'),
        content: TextField(
          controller: controller,
          decoration:
              InputDecoration(hintText: 'Cidade, País (ex: São Paulo, Brasil)'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final input = controller.text.trim();
              if (input.isNotEmpty) {
                await StorageService.saveCity(input);
                city = input;
                Navigator.of(context).pop();
              }
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchCoordinatesAndWeather(String cityName) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$cityName&format=json&limit=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final weather = await MeteoblueService.fetchWeather(lat, lon);

          if (weather == null || weather['data_1h'] == null) {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Não foi possível obter dados de clima para esta cidade.';
            });
          } else {
            setState(() {
              weatherData = weather;
              isLoading = false;
            });
          }
        } else {
          showError('Cidade não encontrada.');
        }
      } else {
        showError('Erro ao buscar coordenadas.');
      }
    } catch (e) {
      showError('Erro inesperado: $e');
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
      errorMessage = message;
    });
  }

  Widget buildWeatherCard() {
    final basicData = weatherData?['data_1h'];

    if (basicData == null) {
      return Text('Dados de clima indisponíveis.');
    }

    final List<dynamic>? temperatures = basicData['temperature'];
    final List<dynamic>? weatherSymbols = basicData['weather_symbol_1h'];

    if (temperatures == null ||
        weatherSymbols == null ||
        temperatures.isEmpty ||
        weatherSymbols.isEmpty) {
      return Text('Dados de clima indisponíveis.');
    }

    final temp = temperatures[0];
    final symbol = weatherSymbols[0];

    String getWeatherIcon(int symbol) {
      if (symbol >= 1 && symbol <= 3) return '☀️';
      if (symbol >= 4 && symbol <= 6) return '⛅';
      if (symbol >= 7 && symbol <= 9) return '☁️';
      if (symbol >= 10 && symbol <= 19) return '🌧️';
      if (symbol >= 20 && symbol <= 29) return '⛈️';
      return '❓';
    }

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                city ?? '',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                getWeatherIcon(symbol),
                style: TextStyle(fontSize: 64),
              ),
              SizedBox(height: 10),
              Text(
                '${temp.toStringAsFixed(1)} °C',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Previsão para agora',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Clima Atual'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.location_city),
            onPressed: () async {
              await askForCity();
              await fetchCoordinatesAndWeather(city!);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildWeatherCard(),
                ),
    );
  }
}
