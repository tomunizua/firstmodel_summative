import 'dart:convert';
import 'package:http/http.dart' as http;
import 'prediction_input.dart';

class ApiService {
  static const String _baseUrl = 'https://demand-prediction-dy30.onrender.com';

  // Fetch prediction
  Future<Map<String, dynamic>> predictDemand(PredictionInput input) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
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
