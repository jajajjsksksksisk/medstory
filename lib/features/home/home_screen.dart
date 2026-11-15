import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../flashcards/flashcards_screen.dart';
import '../last_day/last_day_screen.dart';
import '../review/review_screen.dart';
import '../stories/stories_screen.dart';
import '../subjects/subjects_screen.dart';
import '../upload/upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dueCount = 0;
  int totalCards = 0;
  int notesCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  void _refreshStats() {
    final due = StorageService.getDueCards().length;
    final all = StorageService.getAllCards().length;
    final notes = StorageService.getAllNotes().length;
    setState(() {
      dueCount = due;
      totalCards = all;
      notesCount = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MedStory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStats,
            tooltip: 'Refresh stats',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Study smarter,\nremember longer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Summaries • Flashcards (FSRS) • Stories • Last-day notes',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 28),

            // Stats
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Due today', value: '$dueCount', icon: Icons.schedule)),
                const SizedBox(width: 10),
                Expanded(child: _StatCard(label: 'Total cards', value: '$totalCards', icon: Icons.style)),
                const SizedBox(width: 10),
                Expanded(child: _StatCard(label: 'Notes', value: '$notesCount', icon: Icons.notes)),
              ],
            ),
            const SizedBox(height: 28),

            _ActionCard(
              icon: Icons.upload_file_rounded,
              title: 'Upload / Paste Notes',
              subtitle: 'AI summary + flashcards + stories + last-day notes',
              color: colorScheme.primaryContainer,
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadScreen()));
                _refreshStats();
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.style_rounded,
              title: 'Review Flashcards',
              subtitle: dueCount > 0 ? '$dueCount cards waiting' : 'FSRS spaced repetition',
              color: colorScheme.secondaryContainer,
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewScreen()));
                _refreshStats();
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.flash_on_rounded,
              title: 'Last Day Revision',
              subtitle: 'Ultra-short high-yield notes for final day',
              color: colorScheme.tertiaryContainer,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LastDayScreen()));
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.auto_stories_rounded,
              title: 'Story Mnemonics',
              subtitle: 'Memorable narratives for hard concepts',
              color: colorScheme.surfaceContainerHighest,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StoriesScreen()));
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.folder_special_rounded,
              title: 'Subjects',
              subtitle: 'Browse by Anatomy, Pharma, Patho…',
              color: colorScheme.surfaceContainerHighest,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectsScreen()));
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.library_books_rounded,
              title: 'All Flashcards',
              subtitle: 'Browse and search your cards',
              color: colorScheme.surfaceContainerHighest,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
