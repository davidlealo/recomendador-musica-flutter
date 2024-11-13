import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> obtenerRecomendacion(int userId, int itemId) async {
  final url = Uri.parse('http://localhost:5000/recomendacion?user_id=$userId&item_id=$itemId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['prediccion'];
  } else {
    throw Exception('Error al obtener recomendación');
  }
}
