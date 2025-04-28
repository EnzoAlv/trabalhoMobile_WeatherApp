import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MeteoblueService {
  static const String _sharedSecret = 'MySharedSecret'; // Troque se quiser
  static const String _apiKey = 'qk6K8fe3nAjvQPZ7';
  static const String _baseUrl = 'https://my.meteoblue.com';

  static Future<Map<String, dynamic>?> fetchWeather(
      double lat, double lon) async {
    final expire =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600; // expira em 1h

    // Formatar para 6 casas decimais
    final latFormatted = lat.toStringAsFixed(6);
    final lonFormatted = lon.toStringAsFixed(6);

    final query =
        "/packages/basic-1h?lat=$latFormatted&lon=$lonFormatted&apikey=$_apiKey&expire=$expire";

    final hmac = Hmac(sha256, utf8.encode(_sharedSecret));
    final sig = hmac.convert(utf8.encode(query)).toString();

    final url = Uri.parse("$_baseUrl$query&sig=$sig");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded == null || decoded['data_1h'] == null) {
          print('Resposta sem dados de previsão: $decoded');
          return null;
        }

        return decoded;
      } else {
        print('Erro Meteoblue: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro na conexão com Meteoblue: $e');
      return null;
    }
  }
}
