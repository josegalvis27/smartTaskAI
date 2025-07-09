// 📄 features/task/data/task_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'TU_API_KEY'; // 🔁 Reemplaza por tu clave real
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite-preview-06-17:generateContent?key=';

  static Future<String> enviarPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "system_instruction": {
      "parts": [
        {
          "text": "Actúa como un asistente experto en organización personal, que ayudara a nuestro usuario con los eventos de su calendario. Responde sin hacer preguntas ni pedir más detalles. Da una única respuesta útil y clara según el contenido de la tarea, si son tareas investiga tu mismo, no mandes a investigar. Responde en español."
        }
      ]
    },
        "contents": [ 
          { 
        "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final content = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return content ?? 'Sin respuesta de Gemini.';
    } else {
      throw Exception('Error de Gemini: ${response.body}');
    }
  }
}