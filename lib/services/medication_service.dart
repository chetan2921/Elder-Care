import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:elder_care_assistance/models/medication_reminder.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MedicationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Configure notification settings
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // Initialize notifications
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
      },
    );
    
    // Request permissions for iOS
    await _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  
  Future<void> scheduleMedicationReminder(MedicationReminder reminder) async {
    final now = DateTime.now();
    
    // Calculate next reminder time
    final nextReminder = _getNextReminderTime(reminder, now);
    if (nextReminder == null) return; // No valid upcoming reminder
    
    final scheduledDate = tz.TZDateTime.from(nextReminder, tz.local);
    
    await _notifications.zonedSchedule(
      reminder.id.hashCode, // Use consistent ID for updating existing reminders
      'Medication Reminder',
      'Time to take ${reminder.name} - ${reminder.dosage}',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medications',
          'Medication Reminders',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, androidScheduleMode: null!,
    );
  }
  
  DateTime? _getNextReminderTime(MedicationReminder reminder, DateTime now) {
    // Get the next valid day for the reminder
    int currentDay = now.weekday - 1; // 0-based index (0 = Monday)
    int daysToAdd = 0;
    
    // Check next 7 days to find the next reminder day
    for (int i = 0; i < 7; i++) {
      int checkDay = (currentDay + i) % 7;
      if (reminder.daysOfWeek[checkDay]) {
        daysToAdd = i;
        break;
      }
    }
    
    if (daysToAdd >= 7) return null; // No valid days found
    
    // Create DateTime for next reminder
    DateTime reminderDate = DateTime(
      now.year,
      now.month,
      now.day + daysToAdd,
      reminder.time.hour,
      reminder.time.minute,
    );
    
    // If the time today has already passed, add a week if it's for today
    if (daysToAdd == 0 && reminderDate.isBefore(now)) {
      // Find the next occurrence
      for (int i = 1; i < 7; i++) {
        int checkDay = (currentDay + i) % 7;
        if (reminder.daysOfWeek[checkDay]) {
          reminderDate = reminderDate.add(Duration(days: i));
          break;
        }
      }
    }
    
    return reminderDate;
  }
  
  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }
  
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }
}