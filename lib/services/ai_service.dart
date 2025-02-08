import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AIService {
  static const String apiKeyStorage = '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';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  String _apiKey = '';  // Don't initialize with the actual key
  
  static const Map<String, String> scenarioPrompts = {
    'medical': 'You are a medical assistant helping with medication management. ',
    'emergency': 'You are an emergency response assistant. Provide clear, calm guidance. ',
    'daily': 'You are a daily activities assistant helping with routines and tasks. ',
    'social': 'You are a companion helping maintain social connections and activities. ',
  };

  AIService() {
    _initializeSpeech();
    _initializeTTS();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      _apiKey = await _secureStorage.read(key: apiKeyStorage) ?? '';
      if (_apiKey.isEmpty) {
        throw Exception('API key not found');
      }
    } catch (e) {
      print('Error loading API key: $e');
    }
  }

  Future<void> setApiKey(String apiKey) async {
    if (!apiKey.startsWith('sk-')) {
      throw Exception('Invalid API key format');
    }
    await _secureStorage.write(key: apiKeyStorage, value: apiKey);
    _apiKey = apiKey;
  }

  

  Future<String> getChatResponse(String message, String scenario) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key not set');
    }

    try {
      final prompt = scenarioPrompts[scenario] ?? '';
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '${prompt}Respond with clear, concise, and easy-to-understand answers.',
            },
            {
              'role': 'user',
              'content': message,
            },
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response from AI';
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getChatResponse: $e');
      throw Exception('Error communicating with AI service: $e');
    }
  }

  // These methods need to be implemented
  Future<void> _initializeSpeech() async {
    await _speechToText.initialize();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

  }
  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error in speak: $e');
      throw Exception('Error with text-to-speech: $e');
    }
  }

  Future<String?> startListening() async {
    try {
      if (!await _speechToText.initialize()) {
        throw Exception('Speech to text initialization failed');
      }

      String recognizedText = '';
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: false,
        cancelOnError: true,
      );

      return recognizedText;
    } catch (e) {
      print('Error in startListening: $e');
      throw Exception('Error with speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
    } catch (e) {
      print('Error in stopListening: $e');
      throw Exception('Error stopping speech recognition: $e');
    }
  }
}
