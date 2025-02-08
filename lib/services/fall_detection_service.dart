import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class FallDetectionService {
  bool _isActive = false;
  StreamSubscription? _accelerometerSubscription;
  final void Function()? onFallDetected;

  FallDetectionService({this.onFallDetected});

  void startMonitoring() {
    if (_isActive) return;
    _isActive = true;
    
    // ignore: deprecated_member_use
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Calculate total acceleration magnitude
      double magnitude = _calculateMagnitude(event.x, event.y, event.z);
      
      // Check for sudden acceleration changes indicating a fall
      if (magnitude > 25.0) { // Threshold for fall detection
        if (onFallDetected != null) {
          onFallDetected!();
        }
      }
    });
  }

  void stopMonitoring() {
    _isActive = false;
    _accelerometerSubscription?.cancel();
  }

  double _calculateMagnitude(double x, double y, double z) {
    return (x * x + y * y + z * z).abs();
  }

  bool get isActive => _isActive;
}
