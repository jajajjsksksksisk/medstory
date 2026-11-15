import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/fsrs_service.dart';
import '../../core/services/storage_service.dart';
import '../../shared/models/note_model.dart';
import '../../shared/models/story_model.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _textController = TextEditingController();
  final _topicController = TextEditingController();
  String _subject = AppConstants.defaultSubjects.first;
  bool _isProcessing = false;
  String? _status;

  @override
  void dispose() {
    _textController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _process() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste some notes first')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _status = AiService.hasApiKey
          ? 'Calling Gemini…'
          : 'Demo mode (no API key) – generating sample content…';
    });

    try {
      final result = await AiService.processNotes(
        text: text,
        subject: _subject,
        topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
      );

      setState(() => _status = 'Saving flashcards & stories…');

      final noteId = StorageService.newId();
      final cardIds = <String>[];
      final storyIds = <String>[];

      // Create flashcards
      final cards = result.flashcards.map((c) {
        final card = FsrsService.createNewCard(
          front: c.front,
          back: c.back,
          subject: _subject,
          topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
          noteId: noteId,
        );
        cardIds.add(card.id);
        return card;
      }).toList();

      await StorageService.saveCards(cards);

      // Create stories
      for (final s in result.stories) {
        final story = StoryModel(
          id: StorageService.newId(),
          title: s.title,
          concept: s.concept,
          storyText: s.storyText,
          subject: _subject,
          topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
          noteId: noteId,
          createdAt: DateTime.now(),
        );
        storyIds.add(story.id);
        await StorageService.saveStory(story);
      }

      // Save the note with summary + last-day notes
      final note = NoteModel(
        id: noteId,
        title: result.title,
        originalText: text,
        summary: result.summary,
        lastDayNotes: result.lastDayNotes,
        subject: _subject,
        topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
        createdAt: DateTime.now(),
        flashcardIds: cardIds,
        storyIds: storyIds,
      );
      await StorageService.saveNote(note);

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _status = null;
      });

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Done!'),
          content: Text(
            'Created:\n'
            '• ${result.flashcards.length} flashcards\n'
            '• ${result.stories.length} stories\n'
            '• Summary + Last-day notes\n\n'
            'Subject: $_subject',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _status = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Notes')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subject selector
            DropdownButtonFormField<String>(
              value: _subject,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.defaultSubjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: _isProcessing
                  ? null
                  : (v) => setState(() => _subject = v ?? _subject),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              enabled: !_isProcessing,
              decoration: const InputDecoration(
                labelText: 'Topic (optional)',
                hintText: 'e.g. Cranial nerves, Heart failure',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: !_isProcessing,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Paste lecture notes, PDF text, or high-yield points here…',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
            ),
            if (_status != null) ...[
              const SizedBox(height: 8),
              Text(_status!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isProcessing ? null : _process,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isProcessing ? 'Processing…' : 'Generate Summary + Cards + Stories'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
            const SizedBox(height: 8),
            Text(
              AiService.hasApiKey
                  ? 'Using Gemini AI'
                  : 'Demo mode – add GEMINI_API_KEY for real AI',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
