import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/flashcard_model.dart';
import '../../shared/models/note_model.dart';
import '../../shared/models/story_model.dart';

class StorageService {
  static const _notesBox = 'notes';
  static const _cardsBox = 'flashcards';
  static const _storiesBox = 'stories';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_notesBox);
    await Hive.openBox(_cardsBox);
    await Hive.openBox(_storiesBox);
  }

  // ---------- Notes ----------
  static Future<void> saveNote(NoteModel note) async {
    final box = Hive.box(_notesBox);
    await box.put(note.id, note.toMap());
  }

  static List<NoteModel> getAllNotes() {
    final box = Hive.box(_notesBox);
    return box.values
        .map((e) => NoteModel.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static NoteModel? getNote(String id) {
    final box = Hive.box(_notesBox);
    final data = box.get(id);
    if (data == null) return null;
    return NoteModel.fromMap(Map<String, dynamic>.from(data));
  }

  // ---------- Flashcards ----------
  static Future<void> saveCard(FlashcardModel card) async {
    final box = Hive.box(_cardsBox);
    await box.put(card.id, card.toMap());
  }

  static Future<void> saveCards(List<FlashcardModel> cards) async {
    final box = Hive.box(_cardsBox);
    for (final c in cards) {
      await box.put(c.id, c.toMap());
    }
  }

  static List<FlashcardModel> getAllCards() {
    final box = Hive.box(_cardsBox);
    return box.values
        .map((e) => FlashcardModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<FlashcardModel> getDueCards() {
    final now = DateTime.now();
    return getAllCards()
        .where((c) => c.due.isBefore(now) || c.due.isAtSameMomentAs(now))
        .toList();
  }

  static List<FlashcardModel> getCardsBySubject(String subject) {
    return getAllCards().where((c) => c.subject == subject).toList();
  }

  // ---------- Stories ----------
  static Future<void> saveStory(StoryModel story) async {
    final box = Hive.box(_storiesBox);
    await box.put(story.id, story.toMap());
  }

  static List<StoryModel> getAllStories() {
    final box = Hive.box(_storiesBox);
    return box.values
        .map((e) => StoryModel.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static String newId() => const Uuid().v4();
}
