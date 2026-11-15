import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../../shared/models/note_model.dart';

/// Last Day Revision – ultra-condensed high-yield notes for the final day before exams.
class LastDayScreen extends StatelessWidget {
  const LastDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = StorageService.getAllNotes()
        .where((n) => n.lastDayNotes != null && n.lastDayNotes!.trim().isNotEmpty)
        .toList();

    // Group by subject
    final bySubject = <String, List<NoteModel>>{};
    for (final n in notes) {
      bySubject.putIfAbsent(n.subject, () => []).add(n);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Day Revision'),
      ),
      body: notes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No last-day notes yet', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload notes and generate summaries.\nEach note will also produce a short “Last Day” version.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'High-yield points for the final day',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Open a subject, read the condensed notes, then review the linked flashcards.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                ...bySubject.entries.map((entry) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${entry.value.length} note(s)'),
                      children: entry.value.map((note) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (note.topic != null) ...[
                                const SizedBox(height: 2),
                                Text(note.topic!, style: Theme.of(context).textTheme.bodySmall),
                              ],
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  note.lastDayNotes!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
