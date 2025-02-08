import 'package:elder_care_assistance/models/medication_reminder.dart';
import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final MedicationReminder medication;
  final VoidCallback onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDelete,
  });

  String _formatDays() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = <String>[];
    
    for (int i = 0; i < medication.daysOfWeek.length; i++) {
      if (medication.daysOfWeek[i]) {
        selectedDays.add(days[i]);
      }
    }
    
    return selectedDays.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    medication.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dosage: ${medication.dosage}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Time: ${medication.time.format(context)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Days: ${_formatDays()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (medication.instructions != null) ...[
              const SizedBox(height: 8),
              Text(
                'Instructions: ${medication.instructions}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (medication.imageUrl != null) ...[
              const SizedBox(height: 8),
              Image.network(
                medication.imageUrl!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
      ),
    );
  }
}