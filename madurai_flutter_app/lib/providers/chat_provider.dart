import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  // Add your Gemini API key here
  static const String apiKey = 'AIzaSyDWcfX9UXRsM6edeZM-P5oAV98SctHBZcs';
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      type: MessageType.user,
    );
    addMessage(userMessage);

    // Add loading message
    _isTyping = true;
    notifyListeners();

    try {
      final response = await _getGeminiResponse(text);
      _isTyping = false;
      
      // Add bot message
      final botMessage = ChatMessage(
        text: response,
        type: MessageType.bot,
      );
      addMessage(botMessage);
    } catch (e) {
      _isTyping = false;
      // Add error message
      final errorMessage = ChatMessage(
        text: 'Sorry, I encountered an error: ${e.toString()}',
        type: MessageType.bot,
      );
      addMessage(errorMessage);
    }
  }

  Future<String> _getGeminiResponse(String userMessage) async {
    try {
      // Create request body
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': userMessage
              }
            ]
          }
        ]
      };

      // Send request to Gemini API
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

       

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Extract text from the response
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response from the bot';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Failed to communicate with the AI service: ${e.toString()}';
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}