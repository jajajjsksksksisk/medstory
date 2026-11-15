import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import '../../core/services/fsrs_service.dart';
import '../../core/services/storage_service.dart';
import '../../shared/models/flashcard_model.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<FlashcardModel> _queue;
  int _index = 0;
  bool _showAnswer = false;
  int _reviewed = 0;

  @override
  void initState() {
    super.initState();
    _queue = StorageService.getDueCards();
    // If nothing due, show a few recent cards so user can still practice
    if (_queue.isEmpty) {
      _queue = StorageService.getAllCards().take(10).toList();
    }
  }

  FlashcardModel? get _current =>
      _index < _queue.length ? _queue[_index] : null;

  Future<void> _rate(fsrs.Rating rating) async {
    final card = _current;
    if (card == null) return;

    await FsrsService.review(card, rating);

    setState(() {
      _reviewed++;
      _index++;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('$_reviewed / ${_queue.length}'),
            ),
          ),
        ],
      ),
      body: _current == null ? _empty() : _cardView(),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text('All caught up!', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('No cards due right now.'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _cardView() {
    final card = _current!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Subject tag
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(card.subject),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Question',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      card.front,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_showAnswer) ...[
                      const Divider(height: 40),
                      Text(
                        'Answer',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card.back,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (!_showAnswer)
            FilledButton(
              onPressed: () => setState(() => _showAnswer = true),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('Show Answer'),
            )
          else
            Row(
              children: [
                _btn('Again', Colors.red.shade400, () => _rate(fsrs.Rating.again)),
                const SizedBox(width: 8),
                _btn('Hard', Colors.orange.shade400, () => _rate(fsrs.Rating.hard)),
                const SizedBox(width: 8),
                _btn('Good', Colors.green.shade500, () => _rate(fsrs.Rating.good)),
                const SizedBox(width: 8),
                _btn('Easy', Colors.blue.shade400, () => _rate(fsrs.Rating.easy)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
