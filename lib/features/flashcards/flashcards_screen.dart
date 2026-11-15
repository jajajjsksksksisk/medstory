import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../../shared/models/flashcard_model.dart';

class FlashcardsScreen extends StatelessWidget {
  final String? filterSubject;

  const FlashcardsScreen({super.key, this.filterSubject});

  @override
  Widget build(BuildContext context) {
    var cards = StorageService.getAllCards();
    if (filterSubject != null) {
      cards = cards.where((c) => c.subject == filterSubject).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(filterSubject ?? 'All Flashcards'),
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.style_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No flashcards yet', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Upload notes to generate cards'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cards.length,
              itemBuilder: (context, i) {
                final c = cards[i];
                return _CardTile(card: c);
              },
            ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final FlashcardModel card;
  const _CardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final due = card.isDue;

    return Card(
      child: ExpansionTile(
        leading: Icon(
          due ? Icons.schedule : Icons.check_circle_outline,
          color: due ? Colors.orange : Colors.green,
        ),
        title: Text(
          card.front,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${card.subject}${card.topic != null ? ' • ${card.topic}' : ''}'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Answer', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(card.back),
                const SizedBox(height: 8),
                Text(
                  'State: ${card.state}  •  Reps: ${card.reps}  •  Lapses: ${card.lapses}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
