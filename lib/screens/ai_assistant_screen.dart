import 'package:flutter/material.dart';
import 'package:elder_care_assistance/models/chat_message.dart';
import 'package:elder_care_assistance/services/ai_service.dart';
import 'package:elder_care_assistance/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});
  
  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  late final AIService _aiService;
  late final StorageService _storageService;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  String _currentScenario = 'daily';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _storageService = StorageService(prefs);
      _aiService = AIService();

    await _aiService.setApiKey('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');

      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error initializing services'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _storageService.loadMessages();
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading messages'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSubmitted(String text) async {
  if (text.trim().isEmpty) return;

  _textController.clear();
  final message = ChatMessage(
    text: text,
    isUser: true,
    timestamp: DateTime.now(),
    scenario: _currentScenario,
  );

  setState(() {
    _messages.add(message);
    _isLoading = true;
  });

  try {
    final response = await _aiService.getChatResponse(text, _currentScenario);
    if (response.isNotEmpty) {
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        scenario: _currentScenario,
      );

      if (mounted) {
        setState(() {
          _messages.add(aiMessage);
          _isLoading = false;
        });
      }

      await _storageService.saveMessages(_messages);
      await _aiService.speak(response);
    }
  } catch (e) {
    print('Error in _handleSubmitted: $e');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      String errorMessage = 'An error occurred';
      if (e.toString().contains('API key not found')) {
        errorMessage = 'API key not set. Please check your configuration.';
      } else if (e.toString().contains('insufficient_quota')) {
        errorMessage = 'API quota exceeded. Please check your OpenAI billing.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}

  Future<void> _toggleListening() async {
    try {
      if (!_isListening) {
        final result = await _aiService.startListening();
        if (result != null && mounted) {
          await _handleSubmitted(result);
        }
      } else {
        await _aiService.stopListening();
      }
      
      if (mounted) {
        setState(() {
          _isListening = !_isListening;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error with voice recognition'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
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
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (scenario) {
              setState(() {
                _currentScenario = scenario;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'medical',
                child: Text('Medical Assistant'),
              ),
              PopupMenuItem(
                value: 'emergency',
                child: Text('Emergency Helper'),
              ),
              PopupMenuItem(
                value: 'daily',
                child: Text('Daily Assistant'),
              ),
              PopupMenuItem(
                value: 'social',
                child: Text('Social Companion'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[_messages.length - 1 - index]);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _toggleListening,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}