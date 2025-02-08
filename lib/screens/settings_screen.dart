import 'package:elder_care_assistance/services/ai_service.dart';
import 'package:elder_care_assistance/services/storage_service.dart';
import 'package:flutter/material.dart';
import '../services/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _voiceEnabled = true;
  bool _fallDetectionEnabled = true;
  String _apiKey = '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';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = getIt<StorageService>();
    setState(() {
      _voiceEnabled = prefs.getBool('voice_enabled') ?? true;
      _fallDetectionEnabled = prefs.getBool('fall_detection_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = getIt<StorageService>();
    await prefs.setBool('voice_enabled', _voiceEnabled);
    await prefs.setBool('fall_detection_enabled', _fallDetectionEnabled);
    
    if (_apiKey.isNotEmpty) {
      await getIt<AIService>().setApiKey(_apiKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Voice Features'),
            subtitle: const Text('Enable voice input and output'),
            value: _voiceEnabled,
            onChanged: (value) {
              setState(() => _voiceEnabled = value);
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Fall Detection'),
            subtitle: const Text('Monitor for potential falls'),
            value: _fallDetectionEnabled,
            onChanged: (value) {
              setState(() => _fallDetectionEnabled = value);
              _saveSettings();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: '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',
                helperText: 'Required for AI Assistant',
              ),
              onChanged: (value) => _apiKey = value,
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }
}
