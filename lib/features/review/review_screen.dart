import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart';

/// Simple demo of FSRS review flow.
/// In the real app this will load due cards from storage.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final Scheduler _scheduler;
  Card? _currentCard;
  bool _showAnswer = false;
  int _reviewedCount = 0;

  // Demo content
  final List<Map<String, String>> _demoCards = [
    {
      'front': 'What is the most common cause of community-acquired pneumonia?',
      'back': 'Streptococcus pneumoniae',
    },
    {
      'front': 'First-line treatment for uncomplicated UTI in non-pregnant women?',
      'back': 'Nitrofurantoin or Trimethoprim-sulfamethoxazole (depending on local resistance)',
    },
    {
      'front': 'Cranial nerve responsible for taste on the anterior 2/3 of the tongue?',
      'back': 'Facial nerve (CN VII) via chorda tympani',
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scheduler = Scheduler();
    _loadNextCard();
  }

  void _loadNextCard() {
    if (_currentIndex >= _demoCards.length) {
      setState(() {
        _currentCard = null;
      });
      return;
    }

    // Create a new FSRS card for demo
    final card = Card(cardId: _currentIndex + 1);
    setState(() {
      _currentCard = card;
      _showAnswer = false;
    });
  }

  void _rate(Rating rating) {
    if (_currentCard == null) return;

    final result = _scheduler.reviewCard(_currentCard!, rating);
    // result.card now has updated stability, difficulty, due date etc.

    setState(() {
      _reviewedCount++;
      _currentIndex++;
    });

    _loadNextCard();
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
              child: Text('$_reviewedCount reviewed'),
            ),
          ),
        ],
      ),
      body: _currentCard == null
          ? _buildEmptyState()
          : _buildCardView(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('No more cards due right now.'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView() {
    final front = _demoCards[_currentIndex]['front']!;
    final back = _demoCards[_currentIndex]['back']!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
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
                      front,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_showAnswer) ...[
                      const Divider(height: 48),
                      Text(
                        'Answer',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        back,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!_showAnswer)
            FilledButton(
              onPressed: () => setState(() => _showAnswer = true),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Show Answer'),
            )
          else
            Row(
              children: [
                Expanded(
                  child: _RatingButton(
                    label: 'Again',
                    color: Colors.red.shade400,
                    onPressed: () => _rate(Rating.again),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RatingButton(
                    label: 'Hard',
                    color: Colors.orange.shade400,
                    onPressed: () => _rate(Rating.hard),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RatingButton(
                    label: 'Good',
                    color: Colors.green.shade500,
                    onPressed: () => _rate(Rating.good),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RatingButton(
                    label: 'Easy',
                    color: Colors.blue.shade400,
                    onPressed: () => _rate(Rating.easy),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _RatingButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
