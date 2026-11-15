import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../flashcards/flashcards_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allCards = StorageService.getAllCards();
    final counts = <String, int>{};
    for (final c in allCards) {
      counts[c.subject] = (counts[c.subject] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: AppConstants.defaultSubjects.length,
        itemBuilder: (context, i) {
          final subject = AppConstants.defaultSubjects[i];
          final count = counts[subject] ?? 0;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  subject.substring(0, 1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(subject),
              subtitle: Text(count == 0 ? 'No cards yet' : '$count card(s)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardsScreen(filterSubject: subject),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
