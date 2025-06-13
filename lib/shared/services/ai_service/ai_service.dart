import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/ai_provider.dart';

class AIService {
  static const String _configKey = 'ai_configurations';
  
  static AIService? _instance;
  static AIService get instance => _instance ??= AIService._();
  AIService._();

  List<AIConfiguration> _configurations = [];
  List<AIConfiguration> get configurations => List.unmodifiable(_configurations);

  Future<void> loadConfigurations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_configKey);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _configurations = jsonList
          .map((json) => AIConfiguration.fromJson(json))
          .toList();
    }
  }

  Future<void> saveConfiguration(AIConfiguration config) async {
    // Remove existing configuration for the same provider
    _configurations.removeWhere((c) => c.provider == config.provider);
    
    // Add new configuration
    _configurations.add(config);
    
    await _saveConfigurations();
  }

  Future<void> removeConfiguration(AIProvider provider) async {
    _configurations.removeWhere((c) => c.provider == provider);
    await _saveConfigurations();
  }

  Future<void> _saveConfigurations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      _configurations.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_configKey, jsonString);
  }

  AIConfiguration? getConfiguration(AIProvider provider) {
    try {
      return _configurations.firstWhere((c) => c.provider == provider);
    } catch (e) {
      return null;
    }
  }

  bool hasConfiguration(AIProvider provider) {
    return getConfiguration(provider) != null;
  }

  Future<String> askAI({
    required AIProvider provider,
    required String question,
    String? context,
    ui.Image? image,
  }) async {
    final config = getConfiguration(provider);
    if (config == null) {
      throw Exception('No configuration found for ${provider.displayName}');
    }

    switch (provider) {
      case AIProvider.openai:
        return _askOpenAI(config, question, context, image);
      case AIProvider.gemini:
        return _askGemini(config, question, context, image);
    }
  }

  Future<String> _imageToBase64(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to convert image to bytes');
    }
    final bytes = byteData.buffer.asUint8List();
    return base64Encode(bytes);
  }

  Future<String> _askOpenAI(
    AIConfiguration config, 
    String question, 
    String? context,
    ui.Image? image,
  ) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    
    // Build message content
    List<Map<String, dynamic>> content = [];
    
    if (image != null) {
      final base64Image = await _imageToBase64(image);
      content.add({
        'type': 'image_url',
        'image_url': {
          'url': 'data:image/png;base64,$base64Image',
          'detail': 'high'
        }
      });
    }
    
    final prompt = context != null 
        ? 'Based on this figure/context: $context\n\nQuestion: $question'
        : question;
    
    content.add({
      'type': 'text',
      'text': prompt,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${config.apiKey}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': config.defaultModel.contains('vision') || image != null ? 'gpt-4o' : config.defaultModel,
        'messages': [
          {
            'role': 'user',
            'content': content,
          }
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _askGemini(
    AIConfiguration config, 
    String question, 
    String? context,
    ui.Image? image,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/${config.defaultModel}:generateContent?key=${config.apiKey}'
    );
    
    // Build parts for the request
    List<Map<String, dynamic>> parts = [];
    
    if (image != null) {
      final base64Image = await _imageToBase64(image);
      parts.add({
        'inline_data': {
          'mime_type': 'image/png',
          'data': base64Image
        }
      });
    }
    
    final prompt = context != null 
        ? 'Based on this figure/context: $context\n\nQuestion: $question'
        : question;
    
    parts.add({'text': prompt});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'contents': [
          {
            'parts': parts
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1000,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
    }
  }
}