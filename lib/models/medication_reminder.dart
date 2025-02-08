import 'package:flutter/material.dart';
import 'package:timezone/src/date_time.dart';

class MedicationReminder {
  final String id;
  final String name;
  final String dosage;
  final TimeOfDay time;
  final List<bool> daysOfWeek; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  final String? instructions;
  final String? imageUrl;

  MedicationReminder({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.daysOfWeek,
    this.instructions,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': '${time.hour}:${time.minute}',
      'daysOfWeek': daysOfWeek,
      'instructions': instructions,
      'imageUrl': imageUrl,
    };
  }

  factory MedicationReminder.fromJson(Map<String, dynamic> json) {
    final timeparts = (json['time'] as String).split(':');
    return MedicationReminder(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      time: TimeOfDay(
        hour: int.parse(timeparts[0]),
        minute: int.parse(timeparts[1]),
      ),
      daysOfWeek: List<bool>.from(json['daysOfWeek']),
      instructions: json['instructions'],
      imageUrl: json['imageUrl'],
    );
  }

  TZDateTime? get nextNotificationTime => null;
}
