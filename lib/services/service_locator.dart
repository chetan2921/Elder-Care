import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_service.dart';
import 'storage_service.dart';
import 'medication_service.dart';
import 'fall_detection_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  final secureStorage = const FlutterSecureStorage();

  // Register services
  getIt.registerSingleton<StorageService>(StorageService(prefs));
  getIt.registerSingleton<AIService>(AIService());
  getIt.registerSingleton<MedicationService>(MedicationService());
  getIt.registerSingleton<FallDetectionService>(FallDetectionService());
}