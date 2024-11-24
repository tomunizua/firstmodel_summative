import 'dart:convert';
import 'package:http/http.dart' as http;
import 'prediction_input.dart';

class ApiService {
  static const String _baseUrl = 'https://demand-prediction-dy30.onrender.com';

  Future<Map<String, dynamic>> predictDemand(PredictionInput input) async {
    final url = Uri.parse('$_baseUrl/predict');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to predict demand. Status code: ${response.statusCode}');
    }
  }
}
