import 'package:flutter/material.dart';
import 'package:elder_care_assistance/services/service_locator.dart';
import 'package:elder_care_assistance/services/fall_detection_service.dart';

class FallDetectionScreen extends StatefulWidget {
  const FallDetectionScreen({super.key});

  @override
  _FallDetectionScreenState createState() => _FallDetectionScreenState();
}

class _FallDetectionScreenState extends State<FallDetectionScreen> {
  late final FallDetectionService _fallService;
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _fallService = getIt<FallDetectionService>();
    _isMonitoring = _fallService.isActive;
  }

  void _toggleMonitoring(bool value) {
    setState(() {
      _isMonitoring = value;
    });
    
    if (_isMonitoring) {
      _fallService.startMonitoring();
    } else {
      _fallService.stopMonitoring();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fall Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Fall Detection'),
              subtitle: const Text('Monitor for potential falls'),
              value: _isMonitoring,
              onChanged: _toggleMonitoring,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'When fall detection is enabled, the app will monitor sudden movements '
                'that might indicate a fall. If a fall is detected, emergency contacts '
                'will be notified automatically unless you confirm you are okay.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}