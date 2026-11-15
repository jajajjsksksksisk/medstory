import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

/// Handles all AI calls (summaries, flashcards, stories, last-day notes).
/// Uses Gemini when an API key is provided; otherwise falls back to offline demo mode.
class AiService {
  static bool get hasApiKey => AppConstants.geminiApiKey.isNotEmpty;

  /// Main entry: takes raw notes + subject and returns structured study material.
  static Future<AiStudyResult> processNotes({
    required String text,
    required String subject,
    String? topic,
  }) async {
    if (!hasApiKey) {
      return _offlineDemoResult(text, subject, topic);
    }

    final prompt = '''
You are an expert medical educator helping an MBBS student.

Subject: $subject
${topic != null ? 'Topic: $topic' : ''}

From the notes below, produce a JSON object with exactly these keys:

{
  "title": "short descriptive title",
  "summary": "clear exam-focused bullet points (use markdown bullets)",
  "lastDayNotes": "ultra-condensed high-yield points for last-day revision (max 15 lines)",
  "flashcards": [
    {"front": "question or cloze", "back": "answer"}
  ],
  "stories": [
    {"title": "short title", "concept": "what it teaches", "storyText": "memorable short story (8-15 lines)"}
  ]
}

Rules:
- Make 5–12 high-quality flashcards.
- Stories should be vivid, sequential, and map clearly to the medical facts.
- Focus on high-yield exam material.
- Return ONLY valid JSON, no extra text.

Notes:
$text
''';

    try {
      final response = await _callGemini(prompt);
      final cleaned = _extractJson(response);
      final map = jsonDecode(cleaned) as Map<String, dynamic>;

      return AiStudyResult(
        title: map['title'] as String? ?? 'Untitled',
        summary: map['summary'] as String? ?? '',
        lastDayNotes: map['lastDayNotes'] as String?,
        flashcards: (map['flashcards'] as List? ?? [])
            .map((e) => AiFlashcard(
                  front: e['front'] as String,
                  back: e['back'] as String,
                ))
            .toList(),
        stories: (map['stories'] as List? ?? [])
            .map((e) => AiStory(
                  title: e['title'] as String,
                  concept: e['concept'] as String,
                  storyText: e['storyText'] as String,
                ))
            .toList(),
      );
    } catch (e) {
      // Fallback if AI fails
      return _offlineDemoResult(text, subject, topic);
    }
  }

  static Future<String> _callGemini(String prompt) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/${AppConstants.geminiModel}:generateContent?key=${AppConstants.geminiApiKey}',
    );

    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.4,
        'maxOutputTokens': 4096,
      }
    };

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Gemini error: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    return text;
  }

  static String _extractJson(String raw) {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start == -1 || end == -1) return raw;
    return raw.substring(start, end + 1);
  }

  /// Offline / demo mode so the app is usable without an API key
  static AiStudyResult _offlineDemoResult(
      String text, String subject, String? topic) {
    final short = text.length > 300 ? '${text.substring(0, 300)}...' : text;

    return AiStudyResult(
      title: 'Notes – $subject',
      summary: '''
• Key points extracted from your notes (demo mode).
• Paste a Gemini API key in `lib/core/constants/app_constants.dart` for real AI summaries.

Original excerpt:
$short
''',
      lastDayNotes: '''
LAST-DAY HIGH YIELD ($subject)
• Review the main definitions and lists from your notes
• Focus on repeatedly tested facts
• Use the flashcards generated below
''',
      flashcards: [
        AiFlashcard(
          front: 'What is the main subject of these notes?',
          back: subject,
        ),
        AiFlashcard(
          front: 'Why use spaced repetition (FSRS) for medical facts?',
          back:
              'It schedules reviews when you are about to forget, improving long-term retention with fewer reviews.',
        ),
      ],
      stories: [
        AiStory(
          title: 'Demo Story',
          concept: 'How MedStory helps',
          storyText:
              'A tired MBBS student opened MedStory the night before exams. '
              'The app turned long notes into short bullets, made flashcards that came back at the right time, '
              'and told a short story that locked the hardest list in memory. '
              'Add your Gemini key to unlock real stories for every topic.',
        ),
      ],
    );
  }
}

class AiStudyResult {
  final String title;
  final String summary;
  final String? lastDayNotes;
  final List<AiFlashcard> flashcards;
  final List<AiStory> stories;

  AiStudyResult({
    required this.title,
    required this.summary,
    this.lastDayNotes,
    required this.flashcards,
    required this.stories,
  });
}

class AiFlashcard {
  final String front;
  final String back;
  AiFlashcard({required this.front, required this.back});
}

class AiStory {
  final String title;
  final String concept;
  final String storyText;
  AiStory({
    required this.title,
    required this.concept,
    required this.storyText,
  });
}
