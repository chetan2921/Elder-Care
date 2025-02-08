import 'package:elder_care_assistance/models/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:elder_care_assistance/models/emergency_contact.dart';
import 'package:elder_care_assistance/models/medication_reminder.dart';

class StorageService {
  static const String _contactsKey = 'emergency_contacts';
  static const String _messagesKey = 'chat_message';
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  // Emergency Contacts
  Future<List<EmergencyContact>> loadContacts() async {
    final contactsJson = _prefs.getStringList(_contactsKey) ?? [];
    return contactsJson
        .map((json) => EmergencyContact.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveContacts(List<EmergencyContact> contacts) async {
    final contactsJson = contacts
        .map((contact) => jsonEncode(contact.toJson()))
        .toList();
    await _prefs.setStringList(_contactsKey, contactsJson);
  }

  // Medication Reminders
  Future<void> saveMedications(List<MedicationReminder> medications) async {
    final medsJson = medications.map((m) => m.toJson()).toList();
    await _prefs.setString('medications', jsonEncode(medsJson));
  }
  
  Future<List<MedicationReminder>> loadMedications() async {
    final medsJson = _prefs.getString('medications');
    if (medsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(medsJson);
    return decoded.map((m) => MedicationReminder.fromJson(m)).toList();
  }

  // Settings
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) => _prefs.getBool(key);

Future<List<ChatMessage>> loadMessages() async {
    try {
      final messagesJson = _prefs.getStringList(_messagesKey) ?? [];
      return messagesJson
          .map((str) => ChatMessage.fromJson(jsonDecode(str)))
          .toList();
    } catch (e) {
      // If there's an error loading messages, return empty list
      // and clear corrupted data
      await _prefs.remove(_messagesKey);
      return [];
    }
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    try {
      final messagesJson = messages
          .map((msg) => jsonEncode(msg.toJson()))
          .toList();
      await _prefs.setStringList(_messagesKey, messagesJson);
    } catch (e) {
      // Handle save error - could throw or log depending on requirements
      throw Exception('Failed to save messages: $e');
    }
  }

  // Optional: Method to clear all messages
  Future<void> clearMessages() async {
    await _prefs.remove(_messagesKey);
  }

  // Optional: Method to save messages for a specific scenario
  Future<List<ChatMessage>> loadMessagesForScenario(String scenario) async {
    final allMessages = await loadMessages();
    return allMessages.where((msg) => msg.scenario == scenario).toList();
  }
}

