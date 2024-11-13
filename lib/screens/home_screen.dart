import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController itemIdController = TextEditingController();
  String recommendation = "";

  // Función para obtener la recomendación desde el backend
  Future<void> getRecommendation() async {
    final userId = userIdController.text;
    final itemId = itemIdController.text;

    // Asegúrate de reemplazar la URL con la URL de tu servidor backend
    final url = Uri.parse('http://localhost:5000/recomendacion?user_id=$userId&item_id=$itemId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recommendation = "Predicción: ${data['prediccion']}";
        });
      } else {
        setState(() {
          recommendation = "Error al obtener recomendación.";
        });
      }
    } catch (e) {
      setState(() {
        recommendation = "Error de conexión: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendador de Artistas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'ID del Usuario'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: itemIdController,
              decoration: InputDecoration(labelText: 'ID del Artista'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getRecommendation,
              child: Text('Obtener Recomendación'),
            ),
            SizedBox(height: 20),
            Text(
              recommendation,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
