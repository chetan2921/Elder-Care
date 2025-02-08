import 'package:elder_care_assistance/services/medication_service.dart';
import 'package:elder_care_assistance/services/storage_service.dart';
import 'package:elder_care_assistance/widgets/medication_card.dart';
import 'package:elder_care_assistance/widgets/medication_form.dart';
import 'package:flutter/material.dart';
import '../services/service_locator.dart';
import '../models/medication_reminder.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final List<MedicationReminder> _medications = [];
  
  @override
  void initState() {
    super.initState();
    _loadMedications();
  }
  
  Future<void> _loadMedications() async {
    final medications = await getIt<StorageService>().loadMedications();
    setState(() {
      _medications.clear();
      _medications.addAll(medications);
    });
  }

  void _addMedication() {
    showDialog(
      context: context,
      builder: (context) => MedicationForm(
        onSave: (medication) {
          setState(() {
            _medications.add(medication);
          });
          getIt<StorageService>().saveMedications(_medications);
          getIt<MedicationService>().scheduleMedicationReminder(medication);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: ListView.builder(
        itemCount: _medications.length,
        itemBuilder: (context, index) {
          final med = _medications[index];
          return MedicationCard(
            medication: med,
            onDelete: () {
              setState(() {
                _medications.removeAt(index);
              });
              getIt<StorageService>().saveMedications(_medications);
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addMedication,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}